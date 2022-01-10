class BookMetadata
  include ActiveModel::Model

  attr_accessor :backing_type, :backing_object

  def initialize(attributes={})
    super
    backing = attributes["backing"]
  end

  def backing=(backing)
    @backing_type = backing.class.name
    @backing_object = backing
  end

  def x_length
    for_backings({
      "GoogleBookRequests" => (Proc.new do |backing_object|
        parse_dimension(
          backing_object.response.dig("volumeInfo", "dimensions", "width")
        )
      end)
    })
  end

  def y_length
    for_backings({
      "GoogleBookRequests" => (Proc.new do |backing_object|
        parse_dimension(
          backing_object.response.dig("volumeInfo", "dimensions", "height")
        )
      end)
    })
  end

  def z_length
    for_backings({
      "GoogleBookRequests" => (Proc.new do |backing_object|
        parse_dimension(
          backing_object.response.dig("volumeInfo", "dimensions", "thickness")
        )
      end)
    })
  end

  def dimensions
    {
      x: x_length,
      y: y_length,
      z: z_length
    }
  end

  def title
    for_backings({
      "GoogleBookRequests" => (Proc.new do |backing_object|
        backing_object.response.dig("volumeInfo", "title")
      end)
    })
  end

  def isbn
    for_backings({
      "GoogleBookRequests" => (Proc.new do |backing_object|
        backing_object.isbn
      end)
    })
  end

  private

  def for_backings(handlers)
    raise "BackingBlank" if backing_object.blank?

    handler = handlers[backing_type]

    raise "BackingUnknown" if handler.blank?

    if handler.is_a?(Proc)
      handler.call(backing_object)
    else
      handler
    end
  end

  def parse_dimension(str)
    if str.present?
      Unit.new(str).convert_to("in").scalar
    else
      nil
    end
  end
end
