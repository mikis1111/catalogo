module BooksHelper
    def due_date_class(book)
      return "" unless book.due_date.present?
  
      today = Date.current
      days_left = (book.due_date - today).to_i
  
      if days_left < 0
        "overdue"             # scaduto
      elsif days_left <= 7
        "due-soon"            # in scadenza entro 7 giorni
      else
        ""
      end
    end
  end
  