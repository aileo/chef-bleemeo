#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_custom_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_custom_check

property :id,
  String,
  name_property: true,
  identity: true

property :check_type,
  String,
  default: 'tcp',
  equal_to: ['tcp', 'http', 'https', 'nagios']

property :port,
  Integer,
  callbacks: {
    'should be a valid port' => lambda { |p| p > 0 && p < 65535 }
  }

property :address,
  String,
  default: '127.0.0.1',
  regex: [/^(\d{1,3}\.){3}\d{1,3}$/]

property :http_path,
  String,
  default: '/',
  regex: [/^\//]

property :http_status_code,
  Integer,
  callbacks: {
    'should be a valid HTTP status code' => lambda { |p| p >= 200 && p < 600 }
  }

property :check_command,
  String

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/99-service-#{id}.conf"
  # get some attributes from existing configuration file
  if ::File.exist?(path)
    data = YAML.load(::File.read(path))['service'][0]
    check_type data['check_type'] if data['check_type']
    port data['port'] if data['port']
    address data['address'] if data['address']
    http_path data['http_path'] if data['http_path']
    http_status_code data['http_status_code'] if data['http_status_code']
    check_command data['check_command'] if data['check_command']
  end
end

default_action :create
action :create do
  # Create directory to prevent faillure
  directory '/etc/bleemeo/agent.conf.d' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  data = { 'service' => [{
    'id' => id,
    'check_type' => check_type
  }]}

  # nagios specific attribute
  data['service'][0]['check_command'] = check_command if check_type == 'nagios'

  # all except nagios attributes
  unless check_type == 'nagios'
    data['service'][0]['port'] = port
    data['service'][0]['address'] = address
  end

  # http(s) specific attributes
  if ['http', 'https'].include? check_type
    data['service'][0]['http_path'] = http_path
    # Status code could be unset
    if property_is_set?(:http_status_code)
      data['service'][0]['http_status_code'] = http_status_code
    end
  end

  # Write configuration file
  file "/etc/bleemeo/agent.conf.d/99-service-#{new_resource.id}.conf" do
    action :create
    owner 'root'
    group 'root'
    mode '0644'
    content data.to_yaml
    notifies :restart, 'service[bleemeo-agent]'
  end
end

action :delete do
  file "/etc/bleemeo/agent.conf.d/99-service-#{new_resource.id}.conf" do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
