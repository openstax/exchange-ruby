module OpenStax
  module Exchange
    module Client
      class ClientError < StandardError
        def initialize(msg, original=$!)
          super(msg)
          @original = original
        end

        def inspect
          [super, @original.inspect].join(" ")
        end
      end
    end
  end
end
