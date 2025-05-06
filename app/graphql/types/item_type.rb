module Types
  class ItemType < Types::BaseObject
    field :id, ID, null: false
    field :qty, Float
    field :name, String
    field :unit_type, String
    field :price, Float
    field :receipt, ReceiptType, null: false
  end
end
