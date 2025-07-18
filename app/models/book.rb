class Book < ApplicationRecord
    belongs_to :borrower, optional: true
  
    validates :title, presence: true
  
    before_save :gestisci_stato_prestito
  
    private
  
    def gestisci_stato_prestito
      if borrowed
        self.due_date ||= Date.today + 30.days
      else
        self.borrower_id = nil
        self.due_date = nil
      end
    end
  end
  

  
  
