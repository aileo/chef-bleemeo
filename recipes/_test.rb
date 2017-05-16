#
# Cookbook Name:: bleemeo
# Recipe:: _test
#
# /!\ This recipe is dedicated to tests and should not be included in any
# wrapper cookbook.

# Bleemeo-agent install
include_recipe 'bleemeo::install'

bleemeo_tcp_check 'tcp-test' do
  port            3000
end

bleemeo_http_check 'http-test' do
  tls             false
  port            3001
end

bleemeo_http_check 'https-test' do
  tls             true
  port            3002
  status_code     200
end

bleemeo_nagios_check 'nagios-test' do
  command         'test'
end

bleemeo_pull_metric 'pull-http' do
  url 'http://127.0.0.1/pull-http'
  ssl_check false
end

bleemeo_pull_metric 'pull-https' do
  url 'https://127.0.0.1/pull-https'
end

bleemeo_pull_metric 'pull-credentials' do
  url 'https://127.0.0.1/pull-credentials'
  username 'foo'
  password 'bar'
end

bleemeo_prometheus_endpoint 'local-prometheus' do
  url 'http://127.0.0.1/prometheus/metrics'
end
