module OpenStax
  module Exchange
    module Client

      def self.configure
        yield configuration
      end

      def self.configuration
        @configuration ||= Configuration.new
      end

      class Configuration

        def initialize
          use_real_client
        end

        def use_real_client
          @use_real_client = true
        end

        def use_fake_client
          @use_real_client = false
        end

        def use_real_client?
          !!@use_real_client
        end

        def use_fake_client?
          !use_real_client?
        end
      end

      class Client
        def is_real?
          raise NotImplementedError
        end
      end

      def self.clear_client
        @client = nil
      end

      private

      def self.client
        @client ||= create_client
      end

      def self.create_client
        if configuration.use_real_client?
          RealClient.new
        elsif configuration.use_fake_client?
          FakeClient.new
        else
          raise "internal error - don't know how to create client instance"
        end
      end

    end
  end
end