module OpenStax
  module Exchange
    module ClientInstance

      def is_real_client?
        raise NotImplementedError
      end

      def token
        raise NotImplementedError
      end

      def create_identifier
        raise NotImplementedError
      end

      def create_multiple_choice(identifier, resource, trial, answer)
        raise NotImplementedError
      end

    end
  end
end
