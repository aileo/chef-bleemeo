#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_threshold
#
# More information : https://docs.bleemeo.com/agent/configuration/

resource_name :bleemeo_threshold

property  :metric,
          String,
          name_property: true,
          identity: true

property  :file_prefix,
          Integer,
          default: node['bleemeo']['file_prefix']['thresholds'],
          identity: true

property :low_critical, [Integer, nil]
property :low_warning, [Integer, nil]
property :high_warning, [Integer, nil]
property :high_critical, [Integer, nil]

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/#{file_prefix}-thresholds-#{metric}.conf"
  # get some attributes from existing configuration file
  if ::File.exist?(path)
    data = YAML.safe_load(::File.read(path))['thresholds'][metric]
    low_critical data['low_critical'] if data['low_critical']
    low_warning data['low_warning'] if data['low_warning']
    high_warning data['high_warning'] if data['high_warning']
    high_critical data['high_critical'] if data['high_critical']
  end
end

default_action :create
action :create do
  # Create directory to prevent faillure
  directory '/etc/bleemeo/agent.conf.d' do
    recursive true
  end

  th = {}
  th['low_critical'] = new_resource.low_critical if new_resource.low_critical
  th['low_warning'] = new_resource.low_warning if new_resource.low_warning
  th['high_warning'] = new_resource.high_warning if new_resource.high_warning
  th['high_critical'] = new_resource.high_critical if new_resource.high_critical

  # Write configuration file
  file [
    'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-thresholds-#{new_resource.metric}.conf"
  ].join('/') do
    action :create
    content({ 'thresholds' => { new_resource.metric => th } }.to_yaml)
    notifies :restart, 'service[bleemeo-agent]'
  end
end

action :delete do
  file [
    'etc', 'bleemeo', 'agent.conf.d',
    "#{new_resource.file_prefix}-thresholds-#{new_resource.metric}.conf"
  ].join('/') do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
