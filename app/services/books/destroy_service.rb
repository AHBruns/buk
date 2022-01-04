class Books::DestroyService < Patterns::Service
  def initialize(book:)
    @book = book
  end

  def call
    succeeded = false

    TransactionService.call(
      Proc.new do
        succeeded = true if @book.destroy
      end
    )

    {
      succeeded: succeeded,
      book: @book
    }
  end
end