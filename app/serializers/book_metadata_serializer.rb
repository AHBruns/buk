class BookMetadataSerializer < ActiveModel::Serializer
  attributes :title, :isbn, :dimensions, :backing_type

  def read_attribute_for_serialization(attr)
    object.send(attr.to_s)
  end
end
