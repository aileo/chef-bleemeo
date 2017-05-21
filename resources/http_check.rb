#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_http_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_http_check

property :id, String, name_property: true
property :tls, [true, false], default: false
property :port, Integer, required: true
property :address, [String, nil]
property :path, [String, nil]
property :status_code, [Integer, nil]
property :stack, [String, nil]

default_action :create
action :create do
  bleemeo_custom_check id do
    check_type "http#{tls ? 's' : ''}"
    port new_resource.port
    address new_resource.address if new_resource.address
    http_path path if path
    http_status_code status_code if status_code
    stack new_resource.stack
  end
end

action :delete do
  bleemeo_custom_check do
    action :delete
  end
end
