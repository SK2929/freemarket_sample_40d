class CreateCustomersInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :customers_informations do |t|
      t.string :token
      t.references :user
      t.timestamps
    end
  end
end
