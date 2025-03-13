class Item < ApplicationRecord
  validates_presence_of :price, presence: :true
  validates_presence_of :qty, presence: :true
end
