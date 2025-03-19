class AddItemAssociationToReciept < ActiveRecord::Migration[8.0]
  def change
    add_reference :reciepts, :items, foreign_key: true
  end
end
