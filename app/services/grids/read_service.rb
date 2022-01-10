class Grids::ReadService < Patterns::Service
  def initialize(account:, id: nil, name: nil, first: false)
    @account = account
    @id = id
    @name = name
    @first = first
  end

  def call    
    grids = @account.grids
    grids = grids.where(id: @id) if @id.present?
    grids = grids.where(name: @name) if @name.present?
    grids = grids.first if @first
    
    grids
  end
end