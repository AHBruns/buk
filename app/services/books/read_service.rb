class Books::ReadService < Patterns::Service
  def initialize(
    account:,
    id: nil,
    isbn: nil,
    item: nil,
    item_id: nil,
    cell: nil,
    cell_id: nil,
    index: nil,
    grid: nil,
    grid_id: nil,
    first: false
  )
    @account = account
    @id = id
    @isbn = isbn
    @item = item
    @item_id = item_id
    @cell = cell
    @cell_id = cell_id
    @index = index
    @grid = grid
    @grid_id = grid_id
    @first = first
  end

  def call
    books = @account.books
    books = books.where(id: @id) if @id.present?
    books = books.where(isbn: @isbn) if @isbn.present?
    books = books.where(items: @item) if @item.present?
    books = books.where(items: Item.find_by(id: @item_id)) if @item_id.present?
    books = books.joins(:item).where(items: { cell: @cell }) if @cell.present?
    books = books.joins(:item).where(items: { cell_id: @cell_id }) if @cell_id.present?
    books = books.joins(:item).where(items: { index: @index }) if @index.present?
    books = books.joins(item: [:cell]).where(items: { cells: { grid: @grid } }) if @grid.present?
    books = books.joins(item: [:cell]).where(items: { cells: { grid_id: @grid_id } }) if @grid_id.present?
    books = books.first if @first
    
    books
  end
end