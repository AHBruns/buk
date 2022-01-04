class Book < ApplicationRecord
  include Owned
  include Placeable

  validates :isbn, presence: true
end