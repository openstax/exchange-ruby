exchange-ruby
=============

[![Gem Version](https://badge.fury.io/rb/openstax_exchange.svg)](http://badge.fury.io/rb/openstax_exchange)
[![Build Status](https://travis-ci.org/openstax/exchange-ruby.svg?branch=master)](https://travis-ci.org/openstax/exchange-ruby)
[![Code Climate](https://codeclimate.com/github/openstax/exchange-ruby.png)](https://codeclimate.com/github/openstax/exchange-ruby)

A ruby client for interfacing with the OpenStax Exchange API.

Usage
-----

Include the gem in your project:
```rb
gem 'openstax_exchange'
```

Include the following in your script:

```rb
require 'openstax_exchange'
```

Configure the client's knowledge of the Exchange server:

```rb
OpenStax::Exchange.configure do |config|
  config.client_platform_id     = '123'
  config.client_platform_secret = 'abc' ## do not check real secrets into version control!
  config.client_server_url      = 'http://www.example.com:3000/base/path'
  config.client_api_version     = 'v1'
end
```

By default the real Exchange client will be used.  However, the choice can be made explicitly by using the following:

```rb
OpenStax::Exchange.use_real_client
OpenStax::Exchange.use_fake_client
```

If using the fake client, configure the faked server settings:

```rb
OpenStax::Exchange::FakeClient.configure do |config|
  config.registered_platforms   = {'123' => 'abc'}
  config.server_url             = 'http://www.example.com:3000/base/path'
  config.supported_api_versions = ['v1']
end
```

After changing the client configuration, use:
```rb
OpenStax::Exchange.reset!
```
to ensure that the changes take effect.

The following Exhchange API methods are currently supported:
```rb
identifier = OpenStax::Exchange.create_identifier
```
```rb
response = OpenStax::Exchange.record_multiple_choice_answer(identifier, resource_uri, trial, answer)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/exchange-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
