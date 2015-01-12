module OpenStax
  module Exchange

    @use_real_client = true

    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= ClientConfiguration.new
    end

    def self.reset!
      @client = nil
    end

    def self.use_real_client
      @use_real_client = true
    end

    def self.use_fake_client
      @use_real_client = false
    end

    def self.use_real_client?
      !!@use_real_client
    end

    def self.create_identifier
      begin
        client.create_identifier
      rescue StandardError => error
        raise ClientError.new("create_identifier failure", error)
      end
    end

    def self.create_multiple_choice(*args)
      begin
        client.create_multiple_choice(*args)
      rescue StandardError => error
        raise ClientError.new("create_multiple_choice failure", error)
      end
    end

    private

    def self.client
      begin
        @client ||= create_client
      rescue StandardError => error
        raise ClientError.new("initialization failure", error)
      end
    end

    def self.create_client
      if use_real_client?
        RealClient.new configuration
      else
        FakeClient.new configuration
      end
    end

  end
end