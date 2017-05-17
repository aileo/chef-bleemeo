#
# Cookbook Name:: bleemeo
# Recipe:: default
#

include_recipe 'bleemeo::install'

# include orphan-recipe if any and bleemeo agent is out of sync with
# Bleemeo cloud platform
ruby_block 'orphan agent' do
  only_if { node['bleemeo']['orphan-recipe'] }
  not_if 'cat /var/lib/bleemeo/facts.yaml | grep serial_number'
  block do
    run_context.include_recipe node['bleemeo']['orphan-recipe']
  end
end
