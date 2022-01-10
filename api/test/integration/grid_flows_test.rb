require "test_helper"

class GridFlowsTest < ActionDispatch::IntegrationTest
  include AuthMethods
  include GridMethods
  include CellMethods

  setup do
    authenticate
  end

  test "create a grid" do
    grid = successful_authenticated_post(
      "/grids/create",
      params: { name: "testGrid" }
    )
  end

  test "read a grid" do
    grid = generate_grid
    assert_equal(
      grid,
      successful_authenticated_post(
        "/grids/read",
        params: { id: grid["id"] }
      )
    )
  end

  test "update a grid" do
    grid = generate_grid
    updated_grid = successful_authenticated_post(
      "/grids/update",
      params: { id: grid["id"], name: "newName" }
    )
    assert_equal(
      {
        **grid,
        "name" => "newName",
        "updated_at" => updated_grid["updated_at"]
      },
      updated_grid
    )
  end

  test "destroy a grid" do
    grid = generate_grid
    assert_equal(
      grid,
      successful_authenticated_post(
        "/grids/destroy",
        params: { id: grid["id"] }
      )
    )
    failed_authenticated_post("/grids/read", params: { id: grid["id"] })
  end

  test "can't destroy a grid with cells" do
    grid = generate_grid
    cell = generate_cell(grid_id: grid["id"])
    assert_equal(
      { "errors"=>["CellsDependency"] },
      failed_authenticated_post("/grids/destroy", params: { id: grid["id"] })
    )
    successful_authenticated_post("/cells/destroy", params: { id: cell["id"] })
    assert_equal(
      grid,
      successful_authenticated_post(
        "/grids/destroy",
        params: { id: grid["id"] }
      )
    )
    failed_authenticated_post("/grids/read", params: { id: grid["id"] })
  end

  test "can't create two grids with the same name" do
    grid = successful_authenticated_post(
      "/grids/create",
      params: { name: "testGrid" }
    )
    assert_equal(
      { "errors"=>["NameTaken"] },
      failed_authenticated_post(
        "/grids/create",
        params: { name: "testGrid" }
      )
    )
  end

  test "can't update a grid to the same name as an existing grid" do
    grid_1 = successful_authenticated_post(
      "/grids/create",
      params: { name: "testGrid1" }
    )
    grid_2 = successful_authenticated_post(
      "/grids/create",
      params: { name: "testGrid2" }
    )
    assert_equal(
      { "errors"=>["NameTaken"] },
      failed_authenticated_post(
        "/grids/update",
        params: { id: grid_2["id"], name: "testGrid1" }
      )
    )
  end
end
