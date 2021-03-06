Bleemeo-cookbook
===

About
---

Bleemeo is a Cloud based monitoring solution. This cookbook deploys the agent
on servers you want to monitor. Free trial is available at https://bleemeo.com/trial

This cookboot is a community contribution and is not officially supported.


Install Bleemeo agent using repositories.
---

### Supported Platforms

- Ubuntu 16.04
- Debian 8
- Centos 7.3
- Fedora 24

### Attributes

#### account (uuid v4)

`node['bleemeo']['account']`

ID of the account to connect node to.

#### key (uuid v4)

`node['bleemeo']['key']`

Registration key to allow node to register.

#### auto-upgrade (boolean)

`node['bleemeo']['auto-upgrade']`

Define version strategy, will upgrade automatically if true or stick to the same
version.

> default to false

#### tags (Array)

`node['bleemeo']['tags']`

List of tags for the agent. Your agent will be tagged with those tags on Bleemeo Cloud Platform.

Only create associated configuration file if `bleemeo::configure` is ran.

> default to ['chef-client']

#### stack (String)

`node['bleemeo']['stack']`

Default services stack for the agent.

Only create associated configuration file if `bleemeo::configure` is ran.

> default to nil

#### file_prefix/service (String)

`node['bleemeo']['file_prefix']['service']`

Default services configuration files prefix.

> default to 90

#### file_prefix/metric (String)

`node['bleemeo']['file_prefix']['metric']`

Default metrics configuration files prefix.

> default to 91

#### file_prefix/thresholds (String)

`node['bleemeo']['file_prefix']['thresholds']`

Default thresholds configuration files prefix.

> default to 92

#### file_prefix/tags (String)

`node['bleemeo']['file_prefix']['tags']`

Default tags configuration files prefix.

> default to 99

### Usage

Include `bleemeo` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[bleemeo::default]"
  ],
  "normal": {
    "bleemeo": {
      "account": "YOUR_ACCOUNT_ID",
      "key": "YOUR_REGISTRATION_KEY"
    }
  },
}
```

### Recipes

#### bleemeo::default / bleemeo::install

Install and configure Bleemeo agent from repositories

#### bleemeo::repositories

Install Bleemeo agent's repositories, included in `bleemeo::install`.

#### bleemeo::configure

Create default Bleemeo agent's configuration folder and files, included in `bleemeo::install`.

### Resources

#### bleemeo_tcp_check

Define a tcp custom check

```ruby
bleemeo_tcp_check 'name' do
  id              String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  port            Integer # required
  address         String  # default to 127.0.0.1
  stack           String  # default to nil
end
```

#### bleemeo_http_check

Define a http(s) custom check

```ruby
bleemeo_http_check 'name' do
  id              String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  tls             [TrueClass, FalseClass] # default to false
  port            Integer # required
  address         String  # default to 127.0.0.1
  path            String  # default to /
  status_code     Integer
  stack           String  # default to nil
end
```

#### bleemeo_nagios_check

Define a nagios custom check

```ruby
bleemeo_nagios_check 'name' do
  id              String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  command         String  # required
  stack           String  # default to nil
end
```

#### bleemeo_pull_metric

Define a custom poll metric.

```ruby
bleemeo_pull_metric 'name' do
  id              String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  url             String  # required
  item            [String, nil]
  ssl_check       [TrueClass, FalseClass]  # default to true
  username        [String, nil]
  password        [String, nil]
end
```

#### bleemeo_prometheus_endpoint

Define a custom prometheus endpoint.

```ruby
bleemeo_prometheus_endpoint 'name' do
  id              String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  url             String  # required
end
```

#### bleemeo_threshold

Define default threshold for specified metric,
overwritten by Bleemeo cloud platform.

```ruby
bleemeo_prometheus_endpoint 'name' do
  metric          String  # default to 'name' if not specified
  file_prefix     Integer # configuration file prefix
  low_critical    Integer
  low_warning     Integer
  high_warning    Integer
  high_critical   Integer
end
```

#### bleemeo_postgresql

Set prostgresql monitoring configuration

```ruby
bleemeo_postgresql 'name' do
  file_prefix     Integer # configuration file prefix
  username        String  # required
  password        String  # required
  port            Integer # default to 5432
  address         String  # default to 127.0.0.1
  stack           String  # default to nil
end
```

### Development

Install gems from Gemfile :

```sh
bundler install
```

#### Linter

Foodcritic :

```sh
foodcritic .
```

Rubocop

```sh
rubocop -D
```

#### Tests

**Require vagrant and virtualbox.**

Run tests : `kitchen test`

### License (MIT)

Copyright 2017 Matlo

[see LICENSE](./LICENSE)
