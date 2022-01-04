class GoogleBookRequests < ApplicationRecord
  validates :isbn, presence: true, uniqueness: true
  validates :response, presence: true
end
