class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nickname, :string, null: false
  end
end
