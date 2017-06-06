require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'bleemeo-agent' do
  describe package('bleemeo-agent') do
    it { should be_installed }
  end

  describe service('bleemeo-agent') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'Tag configuration' do
  describe file('/etc/bleemeo/agent.conf.d/99-chef-tags.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }

    its(:content_as_yaml) { should include('tags' => include('test')) }
  end
end

describe 'Services configuration' do
  describe file('/etc/bleemeo/agent.conf.d/90-service-tcp-test.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'service' => include(
          'id' => 'tcp-test',
          'check_type' => 'tcp',
          'port' => 3000
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/90-service-http-test.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'service' => include(
          'id' => 'http-test',
          'check_type' => 'http',
          'port' => 3001
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/90-service-https-test.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'service' => include(
          'id' => 'https-test',
          'check_type' => 'https',
          'port' => 3002,
          'http_status_code' => 200
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/90-service-nagios-test.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'service' => include(
          'id' => 'nagios-test',
          'check_type' => 'nagios',
          'check_command' => 'test'
        )
      )
    end
  end
end

describe 'Metric definition' do
  describe file('/etc/bleemeo/agent.conf.d/91-metric-pull-http.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'metric' => include(
          'pull' => include(
            'pull-http' => include(
              'url' => 'http://127.0.0.1/pull-http',
              'ssl_check' => false
            )
          )
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/91-metric-pull-https.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'metric' => include(
          'pull' => include(
            'pull-https' => include(
              'url' => 'https://127.0.0.1/pull-https'
            )
          )
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/91-metric-pull-credentials.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'metric' => include(
          'pull' => include(
            'pull-credentials' => include(
              'url' => 'https://127.0.0.1/pull-credentials',
              'username' => 'foo',
              'password' => 'bar'
            )
          )
        )
      )
    end
  end

  describe file('/etc/bleemeo/agent.conf.d/91-metric-local-prometheus.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'metric' => include(
          'prometheus' => include(
            'local-prometheus' => include(
              'url' => 'http://127.0.0.1/prometheus/metrics'
            )
          )
        )
      )
    end
  end
end

describe 'Threshold definition' do
  describe file('/etc/bleemeo/agent.conf.d/92-thresholds-fake_metric.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content_as_yaml) do
      should include(
        'thresholds' => include(
          'fake_metric' => include(
            'low_critical' => 0,
            'low_warning' => 2,
            'high_warning' => 90,
            'high_critical' => 95
          )
        )
      )
    end
  end
end
