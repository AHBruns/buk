class Cells::UpdateService < Patterns::Service
  def initialize(cell:, x: nil, y: nil, grid: nil)
    @cell = cell
    @x = x
    @y = y
    @grid = grid
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