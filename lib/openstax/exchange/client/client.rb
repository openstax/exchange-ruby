module OpenStax
  module Exchange
    module Client

      def self.configure
        yield configuration
      end

      def self.configuration
        @configuration ||= ClientConfiguration.new
      end

      def self.clear_client
        @client = nil
      end

      def self.create_identifier
        begin
          client.create_identifier
        rescue => error
          raise ClientError.new("create_identifier failure", error)
        end
      end

      def self.create_multiple_choice(*args)
        begin
          client.create_multiple_choice(*args)
        rescue => error
          raise ClientError.new("create_multiple_choice failure", error)
        end
      end

      private

      def self.client
        begin
          @client ||= create_client
        rescue => error
          raise ClientError.new("initialization failure", error)
        end
      end

      def self.create_client
        if configuration.use_real_client?
          RealClient.new configuration
        elsif configuration.use_fake_client?
          FakeClient.new configuration
        else
          raise "internal error - don't know how to create client instance"
        end
      end

    end
  end
end