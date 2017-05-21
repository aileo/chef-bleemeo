#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_tcp_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_tcp_check

property :id, String, name_property: true
property :port, Integer, required: true
property :address, [String, nil]
property :stack, [String, nil]

default_action :create
action :create do
  bleemeo_custom_check id do
    check_type 'tcp'
    port new_resource.port
    address new_resource.address if new_resource.address
    stack new_resource.stack
  end
end

action :delete do
  bleemeo_custom_check do
    action :delete
  end
end
