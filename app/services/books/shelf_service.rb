class Books::ShelfService < Patterns::Service
  include Failable

  def initialize(account:, book:, cell: nil, index: nil)
    @account = account
    @book = book
    @cell = cell
    @index = index
  end

  def call
    succeeded = false
    new_item = @cell.items.new(account: @account, cell: @cell, index: @index, placeable: @book)

    TransactionService.call(
      Proc.new do
        succeeded = true if new_item.save
      end
    )

    @book.errors.merge!(new_item)

    {
      succeeded: succeeded,
      book: @book
    }
  end
end