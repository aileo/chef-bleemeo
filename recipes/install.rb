#
# Cookbook Name:: bleemeo
# Recipe:: install
#

include_recipe 'bleemeo::repositories'
include_recipe 'bleemeo::configure'

package 'epel-release' do
  only_if { node['platform'] == 'centos' }
end

package 'bleemeo-agent' do
  action node['bleemeo']['auto-upgrade'] ? :upgrade : :install
  notifies :restart, 'service[bleemeo-agent]'
end

service 'bleemeo-agent' do
  action %i[start enable]
end
