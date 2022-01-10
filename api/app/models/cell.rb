class Cell < ApplicationRecord
  include Owned

  default_scope { order(x: :asc, y: :asc) }

  belongs_to :grid

  has_many :items, dependent: :restrict_with_error

  validates :grid, presence: true
  validates :x, presence: true
  validates :y, presence: true
  validates :grid_id, uniqueness: { scope: [:x, :y] }
end
