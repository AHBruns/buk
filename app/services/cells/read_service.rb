class Cells::ReadService < Patterns::Service
  def initialize(account:, id: nil, x: nil, y: nil, grid: nil, grid_id: nil, first: false)
    @account = account
    @id = id
    @x = x
    @y = y
    @grid_id = if grid.present?
      grid.id
    else
      grid_id
    end
    @first = first
  end

  def call    
    cells = @account.cells
    cells = cells.where(id: @id) if @id.present?
    cells = cells.where(x: @x) if @x.present?
    cells = cells.where(y: @y) if @y.present?
    cells = books.joins(item: [:cell]).where(items: { cells: { grid_id: grid_id } }) if @grid_id.present?
    cells = cells.first if @first
    
    cells
  end
end