class Books::MoveService < Patterns::Service
  include Failable

  def initialize(book:, index: nil, cell: nil)
    @book = book
    @index = index
    @cell = cell
  end

  def call
    succeeded = false
    item = @book.item
    
    TransactionService.call(
      Proc.new do
        succeeded = true if item.update(index: @index, cell: @cell)
      end
    )
    
    {
      succeeded: succeeded,
      book: @book
    }
  end
end