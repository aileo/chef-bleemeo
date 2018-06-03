#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_tcp_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_tcp_check

property :id, String, name_property: true
property :file_prefix, [Integer, nil]
property :port, Integer, required: true
property :address, [String, nil]
property :stack, [String, nil]

default_action :create
action :create do
  params = { 'check_type' => 'tcp' }

  params['port'] = new_resource.port if new_resource.port
  params['address'] = new_resource.address if new_resource.address
  params['stack'] = new_resource.stack if new_resource.stack

  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    parameters params
  end
end

action :delete do
  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    action :delete
  end
end
