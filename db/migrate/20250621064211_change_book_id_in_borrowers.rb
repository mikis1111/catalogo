class ChangeBookIdInBorrowers < ActiveRecord::Migration[7.1]
  def change
    if foreign_key_exists?(:borrowers, :books)
      remove_reference :borrowers, :book, foreign_key: true, index: true
    else
      say "No foreign key to remove from borrowers", true
    end
  end
end
