#
# Cookbook Name:: bleemeo
# Resource:: bleemeo_custom_check
#
# More information : https://docs.bleemeo.com/agent/custom-check/

resource_name :bleemeo_custom_check

property  :id,
          String,
          name_property: true,
          identity: true

property  :file_prefix,
          Integer,
          default: node['bleemeo']['file_prefix']['service'],
          identity: true

property  :check_type,
          String,
          default: 'tcp',
          equal_to: ['tcp', 'http', 'https', 'nagios']

property  :port,
          Integer,
          callbacks: {
            'should be a valid port' => lambda do |port|
              port.positive? && port < 65_535
            end
          }

property  :address,
          [String, nil],
          regex: [/^(\d{1,3}\.){3}\d{1,3}$/]

property  :http_path,
          [String, nil],
          regex: [%r{^/}]

property  :http_status_code,
          Integer,
          callbacks: {
            'should be a valid HTTP status code' => lambda do |status|
              status >= 200 && status < 600
            end
          }

property  :check_command,
          String

property  :stack,
          [String, nil]

default_action :create
action :create do
  data = { 'check_type' => check_type }

  # common attributes
  data['port'] = port if port
  data['address'] = address if address
  data['stack'] = stack if stack

  # nagios specific attribute
  data['check_command'] = check_command if check_type == 'nagios'

  # http(s) specific attributes
  if ['http', 'https'].include? check_type
    data['http_path'] = http_path if http_path
    # Status code could be unset
    if property_is_set?(:http_status_code)
      data['http_status_code'] = http_status_code
    end
  end

  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    parameters data
  end
end

action :delete do
  bleemeo_service new_resource.id do
    file_prefix new_resource.file_prefix if new_resource.file_prefix
    action :delete
  end
end
