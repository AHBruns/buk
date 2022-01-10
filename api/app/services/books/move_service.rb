class Books::MoveService < Patterns::Service
  include Failable

  def initialize(book: nil, cell: nil, index: nil)
    @book = book
    @cell = cell
    @index = index
  end

  def call
    return add_error "BookBlank" if @book.blank?
    return add_error "WrongBookClass" unless @book.blank? || @book.is_a?(Book) || @book.acts_like?(:book)

    return failure if has_errors?

    success({
      book: TransactionService.call(
        Proc.new do
          item = @book.item

          unless item.present?
            add_error "ItemBlank"
            raise Exceptions::RollbackAndRaise
          end

          item.update!({ index: @index, cell: @cell }.compact)

          @book
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(type: :taken, attribute: :index, error: "LocationTaken")
    add_record_error_handler(type: :blank, attribute: :index, error: "IndexBlank")

    handle_record_errors invalid.record

    failure
  rescue Exceptions::RollbackAndRaise
    failure
  end
end