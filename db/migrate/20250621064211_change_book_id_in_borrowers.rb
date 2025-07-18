class ChangeBookIdInBorrowers < ActiveRecord::Migration[7.1]
  def change
    remove_reference :borrowers, :book, foreign_key: true, index: true
  end
end
