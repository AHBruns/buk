class Grids::UpdateService < Patterns::Service
  include Failable

  def initialize(grid: nil, name: nil)
    @grid = grid
    @name = name
  end

  def call
    add_error "GridBlank" if @grid.blank?
    unless (
      @grid.blank? ||
      @grid.is_a?(Grid) ||
      @grid.acts_like?(:grid)
    )
      add_error "WrongGridClass" 
    end

    return failure if has_errors?

    success({
      grid: TransactionService.call(
        Proc.new do
          @grid.update!({ name: @name }.compact)
          @grid
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(
      type: :taken,
      attribute: :name,
      error: "NameTaken"
    )

    handle_record_errors invalid.record

    failure
  end
end