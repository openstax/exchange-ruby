module Api
  class MessageEventsController < DummyController
    def create
      dummy(:messages)
    end
  end
end