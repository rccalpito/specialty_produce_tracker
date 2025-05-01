# frozen_string_literal: true

module Types
  class ReceiptType < Types::BaseObject
    field :id, ID, null: false
    field :purchase_date, GraphQL::Types::ISO8601DateTime
    field :total_price, Float
    field :receipt_number, String
    field :items, [Types::ItemType], null: false
  end
end
