class CreateReciepts < ActiveRecord::Migration[8.0]
  def change
    create_table :reciepts do |t|
      t.datetime :purchase_date

      t.timestamps
    end
  end
end
