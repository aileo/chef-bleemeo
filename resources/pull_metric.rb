#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_pull_metric
#
# More information : https://docs.bleemeo.com/agent/custom-metric/

resource_name :bleemeo_pull_metric

property :id, String, name_property: true, identity: true
property :url, String, required: true
property :item, [String, nil]
property :ssl_check, [TrueClass, FalseClass], default: true
property :username, [String, nil]
property :password, [String, nil]

load_current_value do
  path = "/etc/bleemeo/agent.conf.d/99-metric-#{id}.conf"
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

  data = {
    'metric' => { 'pull' => { id => { 'url' => url } } }
  }

  data['metric']['pull'][id]['ssl_check'] = ssl_check unless ssl_check
  data['metric']['pull'][id]['item'] = item if item
  data['metric']['pull'][id]['username'] = username if username
  data['metric']['pull'][id]['password'] = password if password

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
