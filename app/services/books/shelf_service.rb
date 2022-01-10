class Books::ShelfService < Patterns::Service
  include Failable

  def initialize(account: nil, book: nil, cell: nil, index: nil)
    @account = account
    @book = book
    @cell = cell
    @index = index
  end

  def call
    add_error "AccountBlank" if @account.blank?
    add_error "WrongAccountClass" unless @account.blank? || @account.is_a?(Account) || @account.acts_like?(:account)
    add_error "BookBlank" if @book.blank?
    add_error "WrongBookClass" unless @book.blank? || @book.is_a?(Book) || @book.acts_like?(:book)
    add_error "AlreadyShelved" if @book&.item&.present?

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          @account.items.new(cell: @cell, index: @index, placeable: @book).save!
          @book.reload
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(type: :taken, attribute: :index, error: "LocationTaken")
    add_record_error_handler(type: :blank, attribute: :index, error: "IndexBlank")

    handle_record_errors invalid.record

    failure
  end
end