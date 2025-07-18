class AddDueDateToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :due_date, :date
  end
end
