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

file '/etc/bleemeo/agent.conf.d/99-chef-tags.conf' do
  content({ 'tags' => node['bleemeo']['tags'].dup }.to_yaml)
  notifies :restart, 'service[bleemeo-agent]'
end
