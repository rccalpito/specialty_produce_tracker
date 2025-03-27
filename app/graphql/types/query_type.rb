# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :receipts, [ Types::ReceiptType ], null: true, description: "Fetches all receipts"
    field :items, [ Types::ItemType ], null: true, description: "Fetches all items"

    def receipts
      Receipt.all
    end

    def items
      Item.all
    end
  end
end
