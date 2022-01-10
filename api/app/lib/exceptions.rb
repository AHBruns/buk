module Exceptions
  class ServiceFailedWithoutErrors < StandardError
    attr_reader :service, :service_name

    def initialize(service)
      @service = service
      @service_name = service.class.name
      super
    end
  end

  class UnhandledModelError < StandardError
    attr_reader :error

    def initialize(error)
      @error = error
      super error.details
    end
  end

  class RollbackAndRaise < ActiveRecord::ActiveRecordError; end
end