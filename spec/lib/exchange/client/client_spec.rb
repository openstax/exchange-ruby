require 'spec_helper'

describe Exchange::Client do
  describe "test_func" do 
    it "doesn't throw an exception" do
      expect{
        Exchange::Client.test_func
      }.to_not raise_error
    end
  end
end
