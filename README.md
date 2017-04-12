Bleemeo-cookbook
===

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

### Usage

#### bleemeo::default

Include `bleemeo` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef-bleemeo::default]"
  ],
  "normal": {
    "bleemeo": {
      "account": "YOUR_ACCOUNT_ID",
      "key": "YOUR_REGISTRATION_KEY"
    }
  },
}
```

### Tests

**Require vagrant and virtualbox.**

Install gems (bershshelf, test-kitchen, kitchen-vagrant) : `bundler install`

Run tests : `kitchen test`

### License

MIT
