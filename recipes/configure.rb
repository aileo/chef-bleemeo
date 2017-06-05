#
# Cookbook Name:: bleemeo
# Recipe:: install
#

directory '/etc/bleemeo/agent.conf.d' do
  recursive true
end

template '/etc/bleemeo/agent.conf.d/30-install.conf' do
  source 'config.erb'
  notifies :restart, 'service[bleemeo-agent]'
end

filePrefix = node['bleemeo']['file_prefix']['tags']
file "/etc/bleemeo/agent.conf.d/#{filePrefix}-chef-tags.conf" do
  content({ 'tags' => node['bleemeo']['tags'].dup }.to_yaml)
  notifies :restart, 'service[bleemeo-agent]'
end

file '/etc/bleemeo/agent.conf.d/60-default-stack.conf' do
  action node['bleemeo']['stack'] ? :create : :delete
  content "stack: #{node['bleemeo']['stack']}"
end
