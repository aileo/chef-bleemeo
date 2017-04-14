#
# Cookbook Name:: bleemeo
# Recipe:: install
#

directory '/etc/bleemeo/agent.conf.d' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

template '/etc/bleemeo/agent.conf.d/30-install.conf' do
  source 'config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[bleemeo-agent]'
end

file '/etc/bleemeo/agent.conf.d/99-chef-tags.conf' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content ({ 'tags' => node['bleemeo']['tags'].dup }).to_yaml
  notifies :restart, 'service[bleemeo-agent]'
end
