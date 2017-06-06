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

  if low_critical || low_warning || high_warning || high_critical
    data = { 'thresholds' => {} }
    data['thresholds'][metric] = {}
    data['thresholds'][metric]['low_critical'] = low_critical if low_critical
    data['thresholds'][metric]['low_warning'] = low_warning if low_warning
    data['thresholds'][metric]['high_warning'] = high_warning if high_warning
    data['thresholds'][metric]['high_critical'] = high_critical if high_critical

    # Write configuration file
    file "/etc/bleemeo/agent.conf.d/#{file_prefix}-thresholds-#{metric}.conf" do
      action :create
      content data.to_yaml
      notifies :restart, 'service[bleemeo-agent]'
    end
  end
end

action :delete do
  file "/etc/bleemeo/agent.conf.d/#{file_prefix}-thresholds-#{metric}.conf" do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
