class Item < ApplicationRecord
  enum :unit_type, { per: "per", lbs: "lbs", oz: "oz" }

  belongs_to :receipt

  validates :price, presence: true
  validates :qty, presence: true
end
