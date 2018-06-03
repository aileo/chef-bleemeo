#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_nagios_check
#
# More information : https://docs.bleemeo.com/what-bleemeo-monitors/#postgresql

resource_name :bleemeo_postgresql

property :file_prefix, [Integer, nil]
property :username, String, required: true
property :password, String, required: true
property :port, [Integer, nil], default: 5432
property :address, [String, nil], default: '127.0.0.1'
property :stack, [String, nil]

default_action :create
action :create do
  params = { 'port' => new_resource.port, 'address' => new_resource.address }

  params['username'] = new_resource.username if new_resource.username
  params['password'] = new_resource.password if new_resource.password
  params['stack'] = new_resource.stack if new_resource.stack

  bleemeo_service 'postgresql' do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    parameters params
  end
end

action :delete do
  bleemeo_service 'postgresql' do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    action :delete
  end
end
