require 'spec_helper'

describe OpenStax::Exchange::RealClient, vcr: VCR_OPTS do
  before(:each) do
    OpenStax::Exchange::use_real_client
  end

  it_behaves_like "exchange client api v1"
end
