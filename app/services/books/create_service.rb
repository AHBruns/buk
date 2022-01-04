class Books::CreateService < Patterns::Service
  def initialize(account:, isbn: nil)
    @account = account
    @isbn = isbn
  end

  def call
    succeeded = false
    new_book = @account.books.new(isbn: @isbn)
    request = nil

    TransactionService.call(
      Proc.new do
        raise ActiveRecord::Rollback unless new_book.save

        google_book_service = GoogleBooksService.call(isbn: @isbn)

        request = google_book_service.result[:request]

        raise ActiveRecord::Rollback unless google_book_service.result[:succeeded]

        succeeded = true
      end
    )

    new_book.errors.merge!(request) if request.present?

    {
      succeeded: succeeded,
      book: new_book
    }
  end
end