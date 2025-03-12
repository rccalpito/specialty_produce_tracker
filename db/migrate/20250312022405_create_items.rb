class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.decimal :price
      t.integer :qty

      t.timestamps
    end
  end
end
