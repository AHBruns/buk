module Failable
  extend ActiveSupport::Concern

  included do
    def failable?
      true
    end

    private

    def add_error(error)
      @errors = (@errors || []) << error
    end

    def add_errors(*errors)
      errors.each { |error| add_error error }
    end

    def get_errors
      @errors || []
    end

    def has_errors?
      get_errors.present?
    end

    def add_record_error_handler(type:, attribute:, error:)
      @handlers ||= {}
      @handlers[type] ||= {}
      @handlers[type][attribute] = error
    end

    def handle_record_errors(model)
      model.errors.each do |error|
        handled_error = (@handlers || {}).dig(error.type, error.attribute)

        raise Exceptions::UnhandledModelError.new(error) unless handled_error.present?
          
        add_error handled_error
      end
    end

    def join_service(service) 
      if service.failable?
        unless service.result[:succeeded]
          errors << service.result[:errors]
          raise Exceptions::RollbackAndRaise
        end
      end

      service
    end

    def success(h)
      { **h, succeeded: true }
    end

    def failure
      { errors: get_errors, succeeded: false }
    end
  end

  class_methods do
    def call(*args, **kwargs)
      service = super

      raise Exceptions::ServiceFailedWithoutErrors.new(service: service) unless service.result[:succeeded] || service.result[:errors].present?

      service
    end
  end
end