# todo : break out book creation into service and rename to something like Books::CreateAndGoogleBooksService

class Books::CreateService < Patterns::Service
  include Failable

  def initialize(account: nil, isbn: nil)
    @account = account
    @isbn = isbn
  end

  def call
    add_error "AccountBlank" if @account.blank?
    add_error "WrongAccountClass" unless @account.blank? || @account.is_a?(Account) || @account.acts_like?(:account)

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          book = @account.books.new(isbn: @isbn)
          book.save!
          join_service(GoogleBooksService.call(isbn: @isbn))
          book
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