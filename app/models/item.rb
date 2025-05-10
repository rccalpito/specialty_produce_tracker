class Item < ApplicationRecord
  belongs_to :receipt

  validates :price, presence: true
  validates :qty, presence: true
end
