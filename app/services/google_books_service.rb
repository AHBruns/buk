require 'http'

class GoogleBooksService < Patterns::Service
  include Failable

  def initialize(isbn:)
    @isbn = isbn
  end

  def call
    cached_request = GoogleBookRequests.find_by(isbn: @isbn)

    if cached_request.present?
      return {
        succeeded: true,
        request: cached_request
      }
    end

    uri = URI("https://www.googleapis.com/books/v1/volumes")
    uri.query = URI.encode_www_form({ q: "isbn:#{@isbn}", key: ENV["google_books_api_key"] })
    data = JSON.parse(HTTP.get(uri), { symbolize_names: true })

    if data[:totalItems].blank? || data[:totalItems] != 1
      return {
        succeeded: false,
        request: nil
      }
    end

    succeeded = false
    uri = URI("https://www.googleapis.com/books/v1/volumes/#{data[:items][0][:id]}")
    uri.query = URI.encode_www_form({ key: ENV["google_books_api_key"] })
    google_book_request = GoogleBookRequests.new(isbn: @isbn, response: JSON.parse(HTTP.get(uri)))

    TransactionService.call(
      Proc.new do
        succeeded = true if google_book_request.save
      end
    )

    {
      succeeded: succeeded,
      request: google_book_request
    }
  end
end

# good:   #<URI::HTTPS https://www.googleapis.com/books/v1/volumes?q=isbn%3AtestISBN&key=AIzaSyDNcCSymvDc1toJ-YyKLTkBs_NP1sI2hRw>
# failed: #<URI::HTTPS https://www.googleapis.com/books/v1/volumes?q=isbn%3AtestISBN&key=AIzaSyDNcCSymvDc1toJ-YyKLTkBs_NP1sI2hRw>