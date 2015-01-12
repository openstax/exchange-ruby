exchange-ruby
=============

[![Gem Version](https://badge.fury.io/rb/openstax_exchange.svg)](http://badge.fury.io/rb/openstax_exchange)
[![Build Status](https://travis-ci.org/openstax/exchange-ruby.svg?branch=master)](https://travis-ci.org/openstax/exchange-ruby)
[![Code Climate](https://codeclimate.com/github/openstax/exchange-ruby.png)](https://codeclimate.com/github/openstax/exchange-ruby)

A ruby client for interfacing with the OpenStax Exchange API.

Usage
-----

```rb
require 'openstax_exchange'
```

```rb
OpenStax::Exchange::Client.configure do |config|
  # ... set config options ...
end
```

```rb
OpenStax::Exchange::Client.use_real_client
OpenStax::Exchange::Client.use_fake_client
```

```rb
OpenStax::Exchange::FakeClient.configure do |config|
  # .. set fake client options ...
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/exchange-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
