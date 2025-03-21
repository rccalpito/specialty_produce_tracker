class AddFieldsToReceipt < ActiveRecord::Migration[8.0]
  def change
    add_column :receipts, :total_price, :decimal
    add_column :receipts, :sales_tax, :decimal
    add_column :receipts, :receipt_number, :string
  end
end
