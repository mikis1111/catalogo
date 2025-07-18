class Borrower < ApplicationRecord
  
  has_many :books
  validates :first_name, :last_name, :phone, presence: true
  validates :first_name, uniqueness: { scope: [:last_name, :phone], message: "già registrato con lo stesso nome e numero" }

  def full_name
    "#{first_name} #{last_name}"
  end
end
