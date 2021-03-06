module OpenStax
  module Exchange

    @use_real_client = true

    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
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

    def self.create_identifiers
      begin
        client.create_identifiers
      rescue StandardError => error
        raise ClientError.new("create_identifiers failure", error)
      end
    end

    def self.record_multiple_choice_answer(*args)
      begin
        client.record_multiple_choice_answer(*args)
      rescue StandardError => error
        raise ClientError.new("record_multiple_choice_answer failure", error)
      end
    end

    def self.record_grade(*args)
      begin
        client.record_grade(*args)
      rescue StandardError => error
        raise ClientError.new("record_grade failure", error)
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
