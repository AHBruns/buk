class Cells::CreateService < Patterns::Service
  include Failable

  def initialize(account:, x: nil, y: nil, grid: nil)
    @account = account
    @x = x
    @y = y
    @grid = grid
  end

  def call
    succeeded = false
    new_cell = @account.cells.new(x: @x, y: @y, grid: @grid)

    TransactionService.call(
      Proc.new do
        succeeded = true if new_cell.save
      end
    )

    {
      succeeded: succeeded,
      cell: new_cell
    }
  end
end