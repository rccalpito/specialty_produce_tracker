class AddFieldsToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :name, :string
    add_column :items, :unit_type, :integer, default: 0
  end
end
