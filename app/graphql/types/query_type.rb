# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :receipts, [ Types::ReceiptType ], null: true, description: "Fetches all receipts"
    field :items, [ Types::ItemType ], null: true, description: "Fetches all items" do
      argument :receipt_id, ID, required: true
    end

    field :price_history, [ Types::ItemType ], null: true, description: "Fetches price history on item" do
      argument :name, String, required: true
      argument :receipt_id, ID, required: false
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

    def price_history(name:, receipt_id: nil)
      scope = Item.where(name: name)
      scope = scope.where(receipt_id: receipt_id) if receipt_id.present?
      scope
    end
  end
end
