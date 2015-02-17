# exchange-ruby

[![Gem Version](https://badge.fury.io/rb/openstax_exchange.svg)](http://badge.fury.io/rb/openstax_exchange)
[![Build Status](https://travis-ci.org/openstax/exchange-ruby.svg?branch=master)](https://travis-ci.org/openstax/exchange-ruby)
[![Code Climate](https://codeclimate.com/github/openstax/exchange-ruby.png)](https://codeclimate.com/github/openstax/exchange-ruby)

A ruby client for interfacing with the OpenStax Exchange API.

## Usage

Include the gem in your project:
```rb
gem 'openstax_exchange'
```

Include the following in your script:

```rb
require 'openstax_exchange'
```

### Client Configuration

*NOTE:* After changing the client configuration, use:
```rb
OpenStax::Exchange.reset!
```
to ensure that the changes take effect.

#### Choosing the Client

Two clients are supported:
* a real client which connects to an actual Exchange server
* a fake client which implements a fake of the Exchange server

By default the real Exchange client will be used.  However, the choice can be made explicitly by using the following:

```rb
OpenStax::Exchange.use_real_client
OpenStax::Exchange.use_fake_client
```

#### Configuring the Client

Regardless of which client is used, you must configure the client's knowledge of the Exchange server:

```rb
OpenStax::Exchange.configure do |config|
  config.client_platform_id     = '123'
  config.client_platform_secret = 'abc' ## do not check real secrets into version control!
  config.client_server_url      = 'http://www.example.com:3000/base/path'
  config.client_api_version     = 'v1'
end
```

#### Configuring the Fake Client

The fake client automatically uses the `OpenStax::Exchange.configure` client-side settings, but you must also configure the faked client's server settings:

```rb
OpenStax::Exchange::FakeClient.configure do |config|
  config.registered_platforms   = {'123' => 'abc'}
  config.server_url             = 'http://www.example.com:3000/base/path'
  config.supported_api_versions = ['v1']
end
```

### Supported API Methods

The following Exchange API methods are currently supported:
```rb
identifier = OpenStax::Exchange.create_identifier

response = OpenStax::Exchange.record_multiple_choice_answer(identifier, resource_uri, trial, answer)
```

## Running the Specs

Create a local clone of the repo, and run the following commands:
```rb
bundle install
bundle exec rake
```
The result should be a set of passing specs.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/exchange-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
