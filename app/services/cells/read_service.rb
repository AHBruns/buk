class Cells::ReadService < Patterns::Service
  def initialize(account:, id: nil, x: nil, y: nil, grid: nil, first: false)
    @account = account
    @id = id
    @x = x
    @y = y
    @grid = grid
    @first = first
  end

  def call    
    cells = @account.cells
    cells = cells.where(id: @id) if @id.present?
    cells = cells.where(x: @x) if @x.present?
    cells = cells.where(y: @y) if @y.present?
    cells = books.where(grid: @grid) if @grid.present?
    cells = cells.first if @first
    
    cells
  end
end