require 'net/http'

class GoogleBooksService < Patterns::Service
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

    data = JSON.parse(
      Net::HTTP.get(
        URI("https://www.googleapis.com/books/v1/volumes?q=isbn:#{@isbn}&key=#{ENV["google_books_api_key"]}")
      ),
      { symbolize_names: true }
    )

    if data[:totalItems].blank? || data[:totalItems] != 1
      return {
        succeeded: false,
        request: nil
      }
    end

    succeeded = false
    google_book_request = GoogleBookRequests.new(
      isbn: @isbn,
      response: JSON.parse(
        Net::HTTP.get(
          URI("https://www.googleapis.com/books/v1/volumes/#{data[:items][0][:id]}?key=#{ENV["google_books_api_key"]}")
        )
      )
    )

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