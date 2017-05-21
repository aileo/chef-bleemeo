#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_nagios_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_nagios_check

property :id, String, name_property: true
property :command, String, required: true
property :stack, [String, nil]

default_action :create
action :create do
  bleemeo_custom_check id do
    check_type 'nagios'
    check_command command
    stack new_resource.stack
  end
end

action :delete do
  bleemeo_custom_check do
    action :delete
  end
end
