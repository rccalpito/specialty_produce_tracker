class Item < ApplicationRecord
  belongs_to :reciept

  validates_presence_of :price, presence: :true
  validates_presence_of :qty, presence: :true
end
