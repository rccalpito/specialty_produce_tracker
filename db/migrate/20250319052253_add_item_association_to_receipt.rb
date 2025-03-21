class AddItemAssociationToReceipt < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :receipt, null: false, foreign_key: true
  end
end
