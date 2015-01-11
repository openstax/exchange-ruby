module OpenStax
  module Exchange
    module Client

      module ClientInstance
        def is_real_client?
          raise NotImplementedError
        end

        def token
          raise NotImplementedError
        end
      end

    end
  end
end
