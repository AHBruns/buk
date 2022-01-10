class Books::UnshelfService < Patterns::Service
  include Failable

  def initialize(book: nil)
    @book = book
  end

  def call
    add_error "BookBlank" if @book.blank?
    add_error "WrongBookClass" unless @book.blank? || @book.is_a?(Book) || @book.acts_like?(:book)
    add_error "AlreadyUnshelved" if @book&.item&.blank?

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          @book.item.destroy!
          @book.reload
        end
      ).result
    })
  rescue ActiveRecord::RecordNotDestroyed => invalid
    handle_record_errors invalid.record

    failure
  end
end