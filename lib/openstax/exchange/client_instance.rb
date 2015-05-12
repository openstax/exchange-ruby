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

      def record_multiple_choice_answer(identifier, resource, trial, answer)
        raise NotImplementedError
      end

      def record_grade(identifier, resource, trial, grade)
        raise NotImplementedError
      end

    end
  end
end
