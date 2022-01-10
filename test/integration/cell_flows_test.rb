require "test_helper"

class CellFlowsTest < ActionDispatch::IntegrationTest
  include AuthMethods
  include CellMethods

  setup do
    authenticate
  end

  test "create a cell" do
    generate_cell
  end

  test "read a cell" do
    cell = generate_cell
    successful_authenticated_post("/cells/read", params: { id: cell["id"] })
  end

  test "update a cell" do
    cell = generate_cell
    x, y = Array.new(2) { generate_index }
    cell = successful_authenticated_post(
      "/cells/update",
      params: { id: cell["id"], x: x, y: y }
    )
    assert_equal x, cell["x"]
    assert_equal y, cell["y"]
  end

  test "destroy a cell" do
    cell = generate_cell
    successful_authenticated_post(
      "/cells/destroy",
      params: { id: cell["id"] }
    )
    assert_equal(
      { "errors"=>["NoRecord"] },
      failed_authenticated_post(
        "/cells/read",
        params: { id: cell["id"] }
      )
    )
  end

  test "list cells" do
    cells = Array.new(3) { generate_cell }
    assert_equal(cells, successful_authenticated_post("/cells/list"))
  end

  test "list cells by x" do
    x = generate_index
    cells = Array.new(2) { generate_cell(x: x) }
    generate_cell
    assert_equal(
      cells,
      successful_authenticated_post(
        "/cells/list",
        params: { x: x }
      )
    )
  end

  test "list cells by y" do
    y = generate_index
    cells = Array.new(2) { generate_cell(y: y) }
    generate_cell
    assert_equal(
      cells,
      successful_authenticated_post(
        "/cells/list",
        params: { y: y }
      )
    )
  end

  test "list cells by grid_id" do
    grid = generate_grid
    cells = Array.new(2) { generate_cell(grid_id: grid["id"]) }
    generate_cell
    assert_equal(
      cells,
      successful_authenticated_post(
        "/cells/list",
        params: { grid_id: grid["id"] }
      )
    )
  end

  test "can't create a cell ontop of an existing cell" do
    cell_1 = generate_cell
    assert_equal(
      { "errors"=>["LocationTaken"] },
      failed_authenticated_post(
        "/cells/create",
        params: { x: cell_1["x"], y: cell_1["y"], grid_id: cell_1["grid_id"] }
      )
    )
  end

  test "can't update a cell to be ontop of an existing cell" do
    cell_1 = generate_cell
    cell_2 = generate_cell
    assert_equal(
      { "errors"=>["LocationTaken"] },
      failed_authenticated_post(
        "/cells/update",
        params: {
          id: cell_2["id"],
          x: cell_1["x"],
          y: cell_1["y"],
          grid_id: cell_1["grid_id"]
        }
      )
    )
  end

  test "same x and y on different grid is fine" do
    cell_1 = generate_cell
    generate_cell(x: cell_1["x"], y: cell_1["y"])
  end
end