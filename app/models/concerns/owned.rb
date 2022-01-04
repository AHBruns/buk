module Owned
  extend ActiveSupport::Concern

  included do
    belongs_to :account

    validates :account_id, presence: true
  end
end