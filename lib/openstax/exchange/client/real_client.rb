module OpenStax
  module Exchange
    module Client
      class RealClient < Client
        def is_real?
          true
        end
      end
    end
  end
end
