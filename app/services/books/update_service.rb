class Books::UpdateService < Patterns::Service
  include Failable

  def initialize(book: nil, isbn: nil)
    @book = book
    @isbn = isbn
  end

  def call
    add_error "BookBlank" if @book.blank?
    add_error "WrongBookClass" unless @book.blank? || @book.is_a?(Book) || @book.acts_like?(:book)

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          @book.update!({ isbn: @isbn }.compact)
          join_service(GoogleBooksService.call(isbn: @isbn))
          @book
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(type: :blank, attribute: :isbn, error: "ISBNBlank")

    handle_record_errors invalid.record

    failure
  rescue Exceptions::RollbackAndRaise
    failure
  end
end