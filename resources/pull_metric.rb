#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_pull_metric
#
# More information : https://docs.bleemeo.com/agent/custom-metric/

resource_name :bleemeo_pull_metric

property  :id,
          String,
          name_property: true,
          identity: true

property  :file_prefix,
          Integer,
          default: node['bleemeo']['file_prefix']['metric'],
          identity: true

property :url, String, required: true
property :item, [String, nil]
property :ssl_check, [TrueClass, FalseClass], default: true
property :username, [String, nil]
property :password, [String, nil]

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/#{file_prefix}-metric-#{id}.conf"
  # get some attributes from existing configuration file
  if ::File.exist?(path)
    data = YAML.safe_load(::File.read(path))['metric']['pull'][id]
    url data['url'] if data['url']
    item data['item'] if data['item']
    ssl_check data['ssl_check'] if data['ssl_check']
    username data['username'] if data['username']
    password data['password'] if data['password']
  end
end

default_action :create
action :create do
  # Create directory to prevent faillure
  directory '/etc/bleemeo/agent.conf.d' do
    recursive true
  end

  data = { 'url' => new_resource.url }

  data['ssl_check'] = new_resource.ssl_check unless new_resource.ssl_check
  data['item'] = new_resource.item if new_resource.item
  data['username'] = new_resource.username if new_resource.username
  data['password'] = new_resource.password if new_resource.password

  # Write configuration file
  file [
    '', 'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-metric-#{new_resource.id}.conf"
  ].join('/') do
    content({ 'metric' => { 'pull' => { new_resource.id => data } } }.to_yaml)
    notifies :restart, 'service[bleemeo-agent]'
  end
end

action :delete do
  file [
    '', 'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-metric-#{new_resource.id}.conf"
  ].join('/') do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
