class Books::UpdateService < Patterns::Service
  def initialize(book:, isbn: nil)
    @book = book
    @isbn = isbn
  end

  def call
    succeeded = false
    request = nil

    TransactionService.call(
      Proc.new do
        raise ActiveRecord::Rollback unless @book.update(isbn: @isbn)

        google_book_service = GoogleBooksService.call(isbn: @isbn)

        request = google_book_service.result[:request]

        raise ActiveRecord::Rollback unless google_book_service.result[:succeeded]

        succeeded = true
      end
    )

    {
      succeeded: succeeded,
      book: @book
    }
  end
end