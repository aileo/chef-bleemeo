#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_http_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_http_check

property :id, String, name_property: true
property :tls, [true, false], default: false
property  :port,
          Integer,
          required: true,
          callbacks: {
            'should be a valid port' => lambda do |port|
              port.positive? && port < 65_535
            end
          }

property  :address,
          [String, nil],
          regex: [/^(\d{1,3}\.){3}\d{1,3}$/]

property  :path,
          [String, nil],
          regex: [%r{^/}]

property  :status_code,
          Integer,
          callbacks: {
            'should be a valid HTTP status code' => lambda do |status|
              status >= 200 && status < 600
            end
          }

property :stack, [String, nil]
property :file_prefix, [Integer, nil]

default_action :create
action :create do
  ps = { 'check_type' => "http#{new_resource.tls ? 's' : ''}" }
  ps['port'] = new_resource.port
  ps['address'] = new_resource.address if new_resource.address
  ps['http_path'] = new_resource.path if new_resource.path
  ps['http_status_code'] = new_resource.status_code if new_resource.status_code
  ps['stack'] = new_resource.stack if new_resource.stack

  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    parameters ps
  end
end

action :delete do
  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    action :delete
  end
end
