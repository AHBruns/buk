class Cells::UpdateService < Patterns::Service
  include Failable

  def initialize(cell: nil, grid_id: nil, x: nil, y: nil)
    @cell = cell
    @grid_id = grid_id
    @x = x
    @y = y
  end

  def call
    add_error "CellBlank" if @cell.blank?
    unless (
      @cell.blank? ||
      @cell.is_a?(Cell) ||
      @cell.acts_like?(:cell)
    )
      add_error "WrongCellClass"
    end

    return failure if has_errors?
    
    success({
      cell: TransactionService.call(
        Proc.new do
          @cell.update!({ grid_id: @grid_id, x: @x, y: @y }.compact)
          @cell
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(
      type: :taken,
      attribute: :grid_id,
      error: "LocationTaken"
    )

    handle_record_errors invalid.record

    failure
  end
end