class Item < ApplicationRecord
  enum :unit_type, { per: 0, pound: 1, oz: 2 }

  belongs_to :receipt

  validates :price, presence: true
  validates :qty, presence: true
end
