module Placeable
  extend ActiveSupport::Concern

  included do
    has_one :item, as: :placeable, dependent: :destroy
  end
end