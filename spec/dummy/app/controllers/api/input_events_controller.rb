module Api
  class InputEventsController < DummyController
    def create_multiple_choice
      dummy(:multiple_choices)
    end

    def create_free_response
      dummy(:free_responses)
    end
    
  end
end