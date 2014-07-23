module Api
  class IdentifiersController < DummyController
    def create
      self.class.last_action = :create
      self.class.last_params = params
      render json: {identifier: SecureRandom.hex(32)}
    end
  end
end
