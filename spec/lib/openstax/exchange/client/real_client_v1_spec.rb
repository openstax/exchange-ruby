require 'spec_helper'

describe OpenStax::Exchange::Client::RealClient do
  before(:each) do
    OpenStax::Exchange::Client.use_real_client
  end

  it_behaves_like "exchange client api v1"
end
