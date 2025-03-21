class CreateReceipts < ActiveRecord::Migration[8.0]
  def change
    create_table :receipts do |t|
      t.datetime :purchase_date

      t.timestamps
    end
  end
end
