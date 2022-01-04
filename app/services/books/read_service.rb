class Books::ReadService < Patterns::Service
  def initialize(account:, id: nil, isbn: nil, item: nil, cell: nil, index: nil, grid: nil, first: false)
    @account = account
    @id = id
    @isbn = isbn
    @grid = grid
    @cell = cell
    @item = item
    @index = index
    @first = first
  end

  def call    
    books = @account.books
    books = books.where(id: @id) if @id.present?
    books = books.where(isbn: @isbn) if @isbn.present?
    books = books.joins(:item).where(items: @item) if @item.present?
    books = books.joins(item: [:cell]).where(items: { cells: @cell }) if @cell.present?
    books = books.joins(item: [:cell]).where(items: { cells: { index: @index } }) if @index.present?
    books = books.joins(item: [cell: [:grid]]).where(items: { cells: { grids: @grid } }) if @grid.present?
    books = books.first if @first
    
    books
  end
end