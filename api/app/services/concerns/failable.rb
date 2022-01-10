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

    # todo : add api to handle restrict_dependent_destroy more gracefully (no proc)

    def add_record_error_handler(type:, attribute:, error:)
      @handlers ||= {}
      @handlers[type] ||= {}
      @handlers[type][attribute] = error
    end

    def handle_record_errors(record)
      record.errors.each do |error|
        handled_error = (@handlers || {}).dig(error.type, error.attribute)
        handled_error = handled_error.call(error) if handled_error.is_a?(Proc)

        raise Exceptions::UnhandledModelError.new(error) unless handled_error.present?
          
        add_error handled_error
      end
    end

    def join_service(service) 
      if defined? service.failable? && service.failable?
        unless service.result[:succeeded]
          add_errors *service.result[:errors]
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

    def fail_with(*errors)
      add_errors errors
      failure
    end
  end

  class_methods do
    def call(*args, **kwargs)
      service = super

      unless service.result[:succeeded] || service.result[:errors].present?
        p service.result
        raise Exceptions::ServiceFailedWithoutErrors.new(service: service)
      end

      service
    end
  end
end