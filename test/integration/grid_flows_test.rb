require_relative "integration_helpers"

require "test_helper"

class AuthFlowsTest < ActionDispatch::IntegrationTest
  include IntegrationHelpers

  test "simple 4x4" do
    authenticate

    grid_id = successful_authenticated_post("/grids/create", params: { name: "testGrid" })["id"]

    cell_ids = Set[]
    2.times do |x|
      2.times do |y|
        cell_ids << successful_authenticated_post("/cells/create", params: { x: x, y: y, grid_id: grid_id })["id"]
      end
    end

    successful_authenticated_post("/grids/read", params: { id: grid_id })

    assert_equal "testGrid", @response.parsed_body["name"]

    successful_authenticated_post("/cells/list", params: { grid_id: grid_id })

    assert_equal cell_ids, @response.parsed_body.map{ |cell| cell["id"] }.to_set
  end
end
