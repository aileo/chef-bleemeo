#
# Cookbook Name:: bleemeo
# Recipe:: repositories
#

baseurl = 'https://packages.bleemeo.com'

case node['platform']
when 'debian', 'ubuntu'
  package 'apt-transport-https'

  ['bleemeo-agent', 'collectd', 'telegraf'].each do |repo|
    apt_repository repo do
      uri "#{baseurl}/#{repo}"
      components ['main']
      distribution node['lsb']['codename']
      key '9B8BDA4BE10E9F2328D40077E848FD17FC23F27E'
      keyserver 'keyserver.ubuntu.com'
    end
  end
when 'centos', 'fedora'
  ['bleemeo-agent', 'telegraf'].each do |repo|
    yum_repository "#{repo}-repo" do
      description "#{repo} repository"
      baseurl "#{baseurl}/#{repo}/#{node['platform']}/$releasever/$basearch/"
      gpgkey "#{baseurl}/#{repo}/#{node['platform']}/gpg"
      action :create
    end
  end
end
