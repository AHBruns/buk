class BookSerializer < ActiveModel::Serializer
  attributes :id, :isbn, :metadata, :location

  def metadata
    google_book_request = GoogleBookRequests.find_by(isbn: object.isbn)

    google_book_request&.response
  end

  def location
    return nil unless object.item.present?

    {
      index: object.item.index,
      cell_id: object.item.cell_id
    }
  end
end
