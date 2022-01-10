class Books::DestroyService < Patterns::Service
  include Failable

  def initialize(book: nil)
    @book = book
  end

  def call
    add_error "BookBlank" if @book.blank?
    add_error "WrongBookClass" unless @book.blank? || @book.is_a?(Book) || @book.acts_like?(:book)

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          @book.destroy!
        end
      ).result
    })
  rescue ActiveRecord::RecordNotDestroyed => invalid
    handle_record_errors invalid.record

    failure
  end
end