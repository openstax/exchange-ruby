module OpenStax
  module Exchange
    module Client
      class FakeClient < Client
        def is_real?
          false
        end
      end
    end
  end
end
