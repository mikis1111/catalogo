class AddUniqueIndexToBorrowers < ActiveRecord::Migration[7.1]
  def change
    add_index :borrowers, [:first_name, :last_name, :phone], unique: true, name: 'index_unique_borrowers_on_name_and_phone'
  end
end
