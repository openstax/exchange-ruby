module OpenStax
  module Exchange
    module Client

      class ClientInstanceBase
        def is_real?
          raise NotImplementedError
        end

        def token
          raise NotImplementedError
        end
      end

    end
  end
end
