class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :genre
      t.integer :publication_year
      t.string :isbn
      t.text :description

      t.timestamps
    end
  end
end
