class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name, null: false, index: true
      t.text :description, null: false
      t.string :price, null: false
      t.timestamps
    end
  end
end
