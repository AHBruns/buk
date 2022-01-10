require "test_helper"

module CellMethods
  include AuthMethods
  include GridMethods
  include IndexGenerator

  def generate_cell(x: nil, y: nil, grid_id: nil)
    grid_id = generate_grid["id"] if grid_id.blank?
    x = generate_index if x.blank?
    y = generate_index if y.blank?
    successful_authenticated_post("/cells/create", params: { x: x, y: y, grid_id: grid_id })
  end
end