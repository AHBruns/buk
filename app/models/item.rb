class Item < ApplicationRecord
  include Owned

  default_scope { order(index: :asc) }
  
  belongs_to :cell
  belongs_to :placeable, polymorphic: true

  validates :cell, presence: true
  validates :placeable, presence: true
  validates :placeable_id, uniqueness: { scope: :placeable_type }
  validates :index, presence: true, uniqueness: { scope: :cell_id, allow_blank: true }
end