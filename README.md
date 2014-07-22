exchange-ruby
=============

A rails engine for interfacing with OpenStax Exchange.

Usage
-----

Add the engine to your Gemfile and then run `bundle install`.

Create an `openstax_exchange.rb` initializer in `config/initializers`,
with at least the following contents:

```rb
OpenStax::Exchange.configure do |config|
  config.openstax_exchange_platform_id = 'value_from_openstax_exchange_here'
  config.openstax_exchange_platform_secret = 'value_from_openstax_exchange_here'
end
```

If you're running the OpenStax Exchange server in a dev instance on your
machine, you can specify that instance's local URL with:

```rb
config.openstax_exchange_url = 'http://localhost:3003/'
```

Exchange API
------------

Exchange-ruby provides convenience methods for accessing
the OpenStax Exchange API.

`OpenStax::Exchange.api_call(http_method, url, options = {})` provides a
convenience method capable of making API calls to Exchange. `http_method` can
be any valid HTTP method, and `url` is the desired API URL, without the 'api/'
prefix. Options is a hash that can contain any option that
OAuth2 requests accept, such as :headers, :params, :body, etc,
plus the optional values :api_version (to specify an API version) and
:access_token (to specify an OAuth access token).
