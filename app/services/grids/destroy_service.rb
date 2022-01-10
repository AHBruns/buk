class Grids::DestroyService < Patterns::Service
  include Failable

  def initialize(grid: nil)
    @grid = grid
  end

  def call
    add_error "GridBlank" if @grid.blank?
    unless @grid.blank? || @grid.is_a?(Grid) || @grid.acts_like?(:grid)
      add_error "WrongGridClass"
    end

    return failure if has_errors?

    success({
      grid: TransactionService.call(
        Proc.new do
          @grid.destroy!
        end
      ).result
    })
  rescue ActiveRecord::RecordNotDestroyed => invalid
    add_record_error_handler(
      type: :"restrict_dependent_destroy.has_many",
      attribute: :base,
      error: Proc.new do |error|
        case error.options[:record]
        when "cells"
          "CellsDependency"
        else
          raise Exceptions::UnhandledModelError.new(error)
        end
      end
    )

    handle_record_errors invalid.record

    failure
  end
end