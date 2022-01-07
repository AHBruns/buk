class Cells::UpdateService < Patterns::Service
  include Failable

  def initialize(cell:, x: nil, y: nil, grid: nil, grid_id: nil)
    @cell = cell
    @x = x
    @y = y
    @grid = if grid.present?
      grid
    else
      Grid.find_by(id: grid_id)
    end
  end

  def call
    succeeded = false

    TransactionService.call(
      Proc.new do
        succeeded = true if @cell.update({ x: @x, y: @y, grid: @grid }.compact)
      end
    )

    {
      succeeded: succeeded,
      cell: @cell
    }
  end
end