class Books::CreateAndShelfService < Patterns::Service
  def initialize(account:, isbn: nil, index: nil, cell: nil)
    @account = account
    @isbn = isbn
    @index = index
    @cell = cell
  end

  def call
    succeeded = false
    new_book = nil

    TransactionService.call(
      Proc.new do
        create_book_service = Books::CreateService.call(account: @account, isbn: @isbn)

        new_book = create_book_service.result[:book]

        raise ActiveRecord::Rollback unless create_book_service.result[:succeeded]

        shelf_book_service = Books::ShelfService.call(
          account: @account,
          book: create_book_service.result[:book],
          cell: @cell,
          index: @index
        )

        raise ActiveRecord::Rollback unless shelf_book_service.result[:succeeded]

        succeeded = true
      end
    ).result

    {
      succeeded: succeeded,
      book: new_book
    }
  end
end