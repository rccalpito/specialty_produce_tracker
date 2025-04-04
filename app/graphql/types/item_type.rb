module Types
  class ItemType < Types::BaseObject
    field :id, ID, null: false
    field :qty, Integer
    field :name, String
    field :unit_type, Integer
    field :price, Float
  end
end
