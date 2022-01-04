class Grid < ApplicationRecord
  include Owned

  has_many :cells, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :account_id }
end