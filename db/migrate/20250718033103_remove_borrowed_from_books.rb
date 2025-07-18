class RemoveBorrowedFromBooks < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :borrowed, :boolean
  end
end
