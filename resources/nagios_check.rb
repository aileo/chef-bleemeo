#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_nagios_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_nagios_check

property :id, String, name_property: true
property :file_prefix, [Integer, nil]
property :command, String, required: true
property :port, [Integer, nil]
property :address, [String, nil]
property :stack, [String, nil]

default_action :create
action :create do
  bleemeo_custom_check id do
    check_type 'nagios'
    check_command command
    port new_resource.port if new_resource.port
    address new_resource.address if new_resource.address
    stack new_resource.stack
    file_prefix new_resource.file_prefix if new_resource.file_prefix
  end
end

action :delete do
  bleemeo_custom_check id do
    action :delete
  end
end
