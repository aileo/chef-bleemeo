name             'bleemeo'
maintainer       'matlo'
maintainer_email 'lbonnargent@matlo.com'
license          'All rights reserved'
description      'Installs/Configures bleemeo-agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

issues_url 'https://github.com/aileo/chef-bleemeo/issues'
source_url 'https://github.com/aileo/chef-bleemeo'
license 'MIT'

chef_version '>=12.0.0'

supports 'ubuntu', '=16.04'
supports 'debian', '=8.7'
supports 'centos', '=7.3'
supports 'fedora', '=24.0'
