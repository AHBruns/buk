require "test_helper"

module GridMethods
  include AuthMethods
  include IndexGenerator

  def generate_grid(name: nil)
    name = "grid-#{generate_index}" if name.blank?
    successful_authenticated_post("/grids/create", params: { name: name })
  end
end