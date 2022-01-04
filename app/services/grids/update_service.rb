class Grids::UpdateService < Patterns::Service
  def initialize(grid:, name: nil)
    @grid = grid
    @name = name
  end

  def call
    {
      succeeded: TransactionService.call(
        Proc.new do
          @grid.update({ name: @name }.compact)
        end
      ).result,
      grid: @grid
    }
  end

  attr_reader :succeeded
end