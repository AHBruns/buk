require 'http'

class GoogleBooksService < Patterns::Service
  include Failable

  def initialize(isbn: nil)
    @isbn = isbn
  end

  def call
    add_error "ISBNBlank" if @isbn.blank?

    return failure if has_errors?

    cached_request = GoogleBookRequests.find_by(isbn: @isbn)

    return success({ request: cached_request }) if cached_request.present?

    search_response = search_volumes

    add_error "ResponseInvalid" if search_response[:totalItems] != 1

    return failure if has_errors?

    volume_response = load_volume(search_response[:items][0][:id])

    success({
      request: TransactionService.call(
        Proc.new do
          google_book_request = GoogleBookRequests.new(
            isbn: @isbn,
            response: volume_response
          )
          google_book_request.save!
          google_book_request
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    handle_record_errors invalid.record

    failure
  end

  private

  def search_volumes
    uri = URI("https://www.googleapis.com/books/v1/volumes")
    uri.query = URI.encode_www_form({
      q: "isbn:#{@isbn}",
      key: ENV["google_books_api_key"]
    })
    JSON.parse(HTTP.get(uri), { symbolize_names: true })
  end

  def load_volume(id)
    uri = URI("https://www.googleapis.com/books/v1/volumes/#{id}")
    uri.query = URI.encode_www_form({ key: ENV["google_books_api_key"] })
    JSON.parse(HTTP.get(uri))
  end
end
