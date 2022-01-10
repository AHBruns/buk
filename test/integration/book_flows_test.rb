require "test_helper"

class BookFlowsTest < ActionDispatch::IntegrationTest
  include AuthMethods
  include BookMethods
  include CellMethods
  include GridMethods
  include IndexGenerator

  setup do
    authenticate
    @grid_count = 0
  end

  test "create a book" do
    successful_authenticated_book_post(
      "/books/create",
      params: { isbn: "testISBN" }
    )
  end

  test "shelf a book" do
    successful_authenticated_book_post(
      "/books/shelf",
      params: {
        id: generate_book["id"],
        cell_id: generate_cell["id"],
        index: generate_index
      },
      expect_location: true
    )
  end

  test "read a book" do
    book = generate_book
    assert_equal(
      book,
      successful_authenticated_book_post(
        "/books/read",
        params: { id: book["id"] }
      )
    )
  end

  test "update a book" do
    book = generate_book
    assert_equal(
      "newTestISBN",
      (successful_authenticated_book_post(
        "/books/update",
        params: { id: book["id"], isbn: "newTestISBN" }
      )["isbn"])
    )
  end

  test "destroy a book" do
    book = generate_book
    successful_authenticated_book_post(
      "/books/destroy",
      params: { id: book["id"] }
    )
    failed_authenticated_post("/books/read", params: { id: book["id"] })
  end

  test "create and shelf a book in one request" do
    successful_authenticated_book_post(
      "/books/create_and_shelf",
      params: {
        isbn: "testISBN",
        cell_id: generate_cell["id"],
        index: generate_index
      },
      expect_location: true
    )
  end

  test "move a shelved book" do
    book = generate_shelved_book
    successful_authenticated_book_post(
      "/books/move",
      params: {
        id: book["id"],
        cell_id: generate_cell["id"],
        index: generate_index
      },
      expect_location: true
    )
  end

  test "unshelf a shelved book" do
    book = generate_shelved_book
    successful_authenticated_book_post(
      "/books/unshelf",
      params: { id: book["id"] }
    )
  end

  test "listing books" do
    books = Array.new(3) { generate_book }
    assert_equal(
      books,
      successful_authenticated_post("/books/list", params: {})
    )
  end

  test "can't shelve books in the same location" do
    book_1 = generate_shelved_book
    book_2 = generate_book
    assert_equal(
      { "errors" => ["LocationTaken"] },
      failed_authenticated_post(
        "/books/shelf",
        params: {
          id: book_2["id"],
          index: book_1["location"]["index"],
          cell_id: book_1["location"]["cell_id"]
        }
      )
    )
  end

  test "can shelve books in the same index if cell is different" do
    index = generate_index
    generate_shelved_book(index: index)
    generate_shelved_book(index: index)
  end

  test "can shelve books in the same cell if index is different" do
    cell = generate_cell
    generate_shelved_book(cell_id: cell["id"])
    generate_shelved_book(cell_id: cell["id"])
  end

  test "can't move books to the same location" do
    book_1 = generate_shelved_book
    book_2 = generate_shelved_book
    assert_equal(
      { "errors" => ["LocationTaken"] },
      failed_authenticated_post(
        "/books/move",
        params: {
          id: book_2["id"],
          cell_id: book_1["location"]["cell_id"],
          index: book_1["location"]["index"]
        }
      )
    )
  end

  test "listing books by isbn" do
    books = Array.new(2) { generate_book(isbn: "isbn") }
    generate_book
    generate_shelved_book
    assert_equal(
      books,
      successful_authenticated_post("/books/list", params: { isbn: "isbn" })
    )
  end

  test "listing books by cell" do
    cell_1 = generate_cell
    books = Array.new(2) { generate_shelved_book(cell_id: cell_1["id"]) }
    generate_book
    generate_shelved_book
    assert_equal(
      books,
      successful_authenticated_post(
        "/books/list",
        params: { cell_id: cell_1["id"] }
      )
    )
  end

  test "listing books by index" do
    index = generate_index
    books = Array.new(2) do
      generate_shelved_book(index: index)
    end
    generate_book
    generate_shelved_book
    assert_equal(
      books,
      successful_authenticated_post("/books/list", params: { index: index })
    )
  end

  test "listing books by grid" do
    grid = generate_grid
    books = Array.new(2) do
      generate_shelved_book(cell_id: generate_cell(grid_id: grid["id"])["id"])
    end
    generate_book
    generate_shelved_book
    assert_equal(
      books,
      successful_authenticated_post(
        "/books/list",
        params: { grid_id: grid["id"] }
      )
    )
  end
end