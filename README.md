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

> default to ['chef-client']

### Usage

#### bleemeo::default

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

### Tests

**Require vagrant and virtualbox.**

Install gems (bershshelf, test-kitchen, kitchen-vagrant) : `bundler install`

Run tests : `kitchen test`

### License (MIT)

Copyright 2017 Matlo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
