class AddBorrowerToBooks < ActiveRecord::Migration[7.1]
  def change
    add_reference :books, :borrower, foreign_key: true
  end
end


