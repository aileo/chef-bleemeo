#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_prometheus_endpoint
#
# More information :
# https://docs.bleemeo.com/agent/custom-metric/#send-metrics-with-prometheus

resource_name :bleemeo_prometheus_endpoint

property :id, String, name_property: true, identity: true
property :url, String, required: true

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/99-metric-#{id}.conf"
  # get some attributes from existing configuration file
  if ::File.exist?(path)
    data = YAML.safe_load(::File.read(path))['metric']['prometheus'][id]
    url data['url'] if data['url']
  end
end

default_action :create
action :create do
  # Create directory to prevent faillure
  directory '/etc/bleemeo/agent.conf.d' do
    recursive true
  end

  data = { 'metric' => { 'prometheus' => { id => { 'url' => url } } } }

  # Write configuration file
  file "/etc/bleemeo/agent.conf.d/99-metric-#{new_resource.id}.conf" do
    content data.to_yaml
    notifies :restart, 'service[bleemeo-agent]'
  end
end

action :delete do
  file "/etc/bleemeo/agent.conf.d/99-metric-#{new_resource.id}.conf" do
    action :delete
    notifies :restart, 'service[bleemeo-agent]'
  end
end
