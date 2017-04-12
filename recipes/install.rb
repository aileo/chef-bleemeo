#
# Cookbook Name:: bleemeo
# Recipe:: install
#

include_recipe 'bleemeo::repositories'

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

package 'epel-release' do
  only_if { node['platform'] == 'centos' }
end

package 'bleemeo-agent' do
  action node['bleemeo']['auto-upgrade'] ? :upgrade : :install
  notifies :restart, 'service[bleemeo-agent]'
end

service 'bleemeo-agent' do
  action [:start, :enable]
end
