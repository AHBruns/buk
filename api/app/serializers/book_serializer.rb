class BookSerializer < ActiveModel::Serializer
  attributes :id, :isbn, :metadata, :location

  def metadata
    google_book_request = GoogleBookRequests.find_by(isbn: object.isbn)

    return nil unless google_book_request.present?

    BookMetadataSerializer.new(BookMetadata.new(backing: google_book_request))
  end

  def location
    return nil unless object.item.present?

    {
      index: object.item.index,
      cell_id: object.item.cell_id
    }
  end
end
