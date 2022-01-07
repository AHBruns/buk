class Account < ApplicationRecord
  default_scope { order(email: :asc) }

  has_secure_password

  has_many :cells, dependent: :restrict_with_error
  has_many :grids, dependent: :restrict_with_error
  has_many :items, dependent: :restrict_with_error
  has_many :books, dependent: :restrict_with_error

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
end
