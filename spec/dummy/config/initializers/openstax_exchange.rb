require 'capybara'

# Initializes a Capybara server running the Dummy app
CAPYBARA_SERVER = Capybara::Server.new(Rails.application).boot

OpenStax::Exchange.configure do |config|
  config.openstax_exchange_url = "http://localhost:#{CAPYBARA_SERVER.port}/"
  config.openstax_exchange_platform_id = 'secret'
  config.openstax_exchange_platform_secret = 'secret'
end
