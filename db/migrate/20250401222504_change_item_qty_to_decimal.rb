class ChangeItemQtyToDecimal < ActiveRecord::Migration[8.0]
  def change
    change_column :items, :qty, :decimal, precision: 10, scale: 2
  end
end
