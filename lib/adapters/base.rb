module Adapter
  class Base
    class << self
      def adapter_classes
        @adapter_classes ||= []
      end

      def inherited(klass)
        adapter_classes << klass
      end

      def page_task?
        false
      end

      def domain_task?
        false
      end
    end

    attr_reader :pull, :pull_data

    def initialize(pull, pull_data)
      @pull = pull
      @pull_data = pull_data
    end

    def models
      @models ||=
        begin
          build_models
        rescue
          @exception = true
          nil
        end
    end

    def build_models
      raise NotImplementedError
    end

    def valid?
      !!models && models.all?(&:valid?)
    end

    def save!
      models.each(&:save!)
    end

    def errors
      return [] if valid?

      if @exception
        [{ 'Exception' => "Exception thrown in #{self.class.name} for pull with id #{pull.id}" }]
      else
        models.reduce([]) do |result, model|
          if model.valid?
            result
          else
            result << {
              model: model.class.name,
              message:  model.errors.full_messages,
              adapter: self.class.name
            }
          end
        end.flatten
      end
    end

    def save_errors!
      models&.each(&:destroy)

      errors.each do |error|
        StoredPullError.create \
          pull: pull,
          location: self.class,
          error: error
      end
    end
  end
end
