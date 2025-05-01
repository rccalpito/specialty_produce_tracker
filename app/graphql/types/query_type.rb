# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :receipts, [ Types::ReceiptType ], null: true, description: "Fetches all receipts"
    field :items, [ Types::ItemType ], null: true, description: "Fetches all items" do
      argument :receipt_id, ID, required: true
    end

    field :receipt, Types::ReceiptType, null: false do
      argument :id, ID, required: true
    end

    def receipt(id:)
      Receipt.find(id)
    end

    def receipts
      Receipt.all
    end

    def items(receipt_id:)
      Item.where(receipt_id: receipt_id)
    end
  end
end
