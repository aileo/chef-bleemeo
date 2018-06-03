#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_custom_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_service

property  :id,
          String,
          name_property: true,
          identity: true

property  :file_prefix,
          Integer,
          default: node['bleemeo']['file_prefix']['service'],
          identity: true

property  :parameters,
          Hash

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/#{file_prefix}-service-#{id}.conf"
  # get some attributes from existing configuration file
  if ::File.exist?(path)
    parameters YAML.safe_load(::File.read(path))['service'][0]
  end
end

default_action :create
action :create do
  # Create directory to prevent faillure
  directory '/etc/bleemeo/agent.conf.d' do
    recursive true
  end

  service = new_resource.parameters
  service['id'] = new_resource.id

  # Write configuration file
  file [
    '', 'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-service-#{new_resource.id}.conf"
  ].join('/') do
    action :create
    content({ 'service' => [service] }.to_yaml)
    notifies :restart, 'service[bleemeo-agent]'
  end
end

action :delete do
  file [
    '', 'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-service-#{new_resource.id}.conf"
  ].join('/') do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
