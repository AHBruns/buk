require "test_helper"

module BookMethods
  include AuthMethods
  include CellMethods
  include IndexGenerator

  def successful_authenticated_book_post(url, params: {}, headers: nil, expect_location: false)
    data = successful_authenticated_post(url, params: params, headers: headers)

    assert_equal ["id", "isbn", "metadata", "location"], data.keys
    assert_equal expect_location ? ["id", "isbn", "metadata", "location"] : ["id", "isbn", "metadata"], data.compact.keys

    data
  end

  def generate_book(isbn: nil)
    isbn = "isbn-#{generate_index}" if isbn.blank?
    successful_authenticated_book_post("/books/create", params: { isbn: isbn })
  end

  def generate_shelved_book(isbn: nil, index: nil, cell_id: nil)
    isbn = "isbn-#{generate_index}" if isbn.blank?
    index = generate_index if index.blank?
    cell_id = generate_cell["id"] if cell_id.blank?
    successful_authenticated_book_post("/books/create_and_shelf", params: { isbn: isbn, index: index, cell_id: cell_id }, expect_location: true)
  end
end