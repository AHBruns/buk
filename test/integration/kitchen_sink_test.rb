require "test_helper"

class KitchenSinkTest < ActionDispatch::IntegrationTest
  include AuthMethods

  setup do
    authenticate
  end

  test "kitchen sink" do
    grid_1_id = successful_authenticated_post("/grids/create", params: { name: "testGrid1" })["id"]
    grid_2_id = successful_authenticated_post("/grids/create", params: { name: "testGrid2"})["id"]

    cell_1_1_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 1, grid_id: grid_1_id })["id"]
    cell_2_1_id = successful_authenticated_post("/cells/create", params: { x: 2, y: 1, grid_id: grid_1_id })["id"]
    cell_1_2_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 2, grid_id: grid_1_id })["id"]
    cell_2_2_id = successful_authenticated_post("/cells/create", params: { x: 2, y: 2, grid_id: grid_1_id })["id"]

    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, grid_id: grid_2_id })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, x: 10, grid_id: grid_1_id })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, x: 2, y: 10 })
    successful_authenticated_post("/cells/update", params: { id: cell_2_2_id, y: 2 })

    successful_authenticated_post("/cells/read", params: { id: cell_2_2_id })

    cell_1_1_alt_id = successful_authenticated_post("/cells/create", params: { x: 1, y: 1, grid_id: grid_2_id })["id"]

    book_id = successful_authenticated_post("/books/create", params: { isbn: "testISBN" })["id"]

    successful_authenticated_post("/books/update", params: { id: book_id, isbn: "newTestISBN" })

    successful_authenticated_post("/books/shelf", params: { id: book_id, cell_id: cell_1_1_id, index: 0 })

    failed_authenticated_post("/books/shelf", params: { id: book_id, cell_id: cell_1_1_id, index: 1 })

    successful_authenticated_post("/books/move", params: { id: book_id, cell_id: cell_1_1_id, index: 1 })
    successful_authenticated_post("/books/move", params: { id: book_id, cell_id: cell_1_1_id, index: 0 })
    
    tmp_book_id = successful_authenticated_post("/books/create_and_shelf", params: { isbn: "testISBN", cell_id: cell_1_1_id, index: 1 })["id"]

    failed_authenticated_post("/books/create_and_shelf", params: { isbn: "testISBN", cell_id: cell_1_1_id, index: 1 })

    successful_authenticated_post("/books/unshelf", params: { id: tmp_book_id })

    successful_authenticated_post("/books/destroy", params: { id: tmp_book_id })

    assert_not_nil(successful_authenticated_post("/books/read", params: { id: book_id })["location"])

    assert_equal(
      Set[cell_1_1_id, cell_1_2_id, cell_2_1_id, cell_2_2_id, cell_1_1_alt_id],
      successful_authenticated_post("/cells/list").map{ |cell| cell["id"] }.to_set
    )

    assert_equal(
      Set[cell_1_1_id, cell_1_2_id, cell_2_1_id, cell_2_2_id],
      successful_authenticated_post("/cells/list", params: { grid_id: grid_1_id }).map{ |cell| cell["id"] }.to_set
    )

    assert_equal(Set[book_id], successful_authenticated_post("/books/list").map{ |book| book["id"] }.to_set)
    
    assert_equal(
      Set[cell_1_1_alt_id],
      successful_authenticated_post("/cells/list", params: { grid_id: grid_2_id }).map{ |cell| cell["id"] }.to_set
    )

    assert_equal(
      Set[grid_1_id, grid_2_id],
      successful_authenticated_post("/grids/list").map{ |grid| grid["id"] }.to_set
    )

    successful_authenticated_post("/grids/update", params: { id: grid_1_id, name: "renamedTestGrid1" })

    assert_equal("renamedTestGrid1", successful_authenticated_post("/grids/read", params: { id: grid_1_id })["name"])

    failed_authenticated_post("/cells/destroy", params: { id: cell_1_1_id })

    successful_authenticated_post("/books/destroy", params: { id: book_id })

    successful_authenticated_post("/cells/destroy", params: { id: cell_1_1_id })

    assert_equal(
      Set[cell_1_2_id, cell_2_1_id, cell_2_2_id, cell_1_1_alt_id],
      successful_authenticated_post("/cells/list").map{ |cell| cell["id"] }.to_set
    )

    failed_authenticated_post("/grids/destroy", params: { id: grid_2_id })

    successful_authenticated_post("/cells/destroy", params: { id: cell_1_1_alt_id })

    successful_authenticated_post("/grids/destroy", params: { id: grid_2_id })
  end
end
