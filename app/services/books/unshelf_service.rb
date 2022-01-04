class Books::UnshelfService < Patterns::Service
  def initialize(book:)
    @book = book
  end

  def call
    succeeded = false
    item = @book.item

    TransactionService.call(
      Proc.new do
        succeeded = true if item.blank? || item.destroy
      end
    )

    @book.errors.merge!(item)

    {
      succeeded: succeeded,
      book: @book
    }
  end
end