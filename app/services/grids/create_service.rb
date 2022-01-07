class Grids::CreateService < Patterns::Service
  include Failable

  def initialize(account:, name:)
    @account = account
    @name = name
  end

  def call
    succeeded = false
    new_grid = @account.grids.new({ name: @name }.compact)

    TransactionService.call(
      Proc.new do
        succeeded = true if new_grid.save
      end
    )

    {
      succeeded: succeeded,
      grid: new_grid
    }
  end
end