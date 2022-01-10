class Books::CreateAndShelfService < Patterns::Service
  include Failable

  def initialize(account: nil, isbn: nil, index: nil, cell: nil)
    @account = account
    @isbn = isbn
    @index = index
    @cell = cell
  end

  def call
    success({
      book: TransactionService.call(
        Proc.new do
          book = join_service(Books::CreateService.call(account: @account, isbn: @isbn)).result[:book]
      
          join_service(
            Books::ShelfService.call(
              account: @account,
              book: book,
              cell: @cell,
              index: @index
            )
          )
    
          book
        end
      ).result
    })
  rescue Exceptions::RollbackAndRaise
    failure
  end
end