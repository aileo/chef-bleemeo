#
# Cookbook Name:: bleemeo
# Recipe:: reset
#

# /!\ WARNING : running this recipe against perfectly running agent will result
# in a duplicated agent in Bleemeo cloud platform

file '/var/lib/bleemeo/state.json' do
  action :delete
  notifies :restart, 'service[bleemeo-agent]'
end
