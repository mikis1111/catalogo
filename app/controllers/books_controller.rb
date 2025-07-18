require 'prawn/table'
require 'roo'

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.includes(:borrower).all
  
    if params[:query].present?
      @books = @books.where("title ILIKE ? OR author ILIKE ? OR publisher ILIKE ? OR genre ILIKE ? OR CAST(publication_year AS TEXT) ILIKE ?", 
        *Array.new(5, "%#{params[:query]}%"))
    end
  
    if params[:borrowed] == "1"
      @books = @books.where(borrowed: true)
    end

    @books = @books.order(borrowed: :desc, updated_at: :desc)
  end
  

  def show
    @book = Book.includes(:borrower).find(params[:id])
  end
  

  def new
    @book = Book.new
    
  end
  
  def edit
    @book = Book.find(params[:id])
    @borrowers = Borrower.all
  end
  

  def create
    @book = Book.new(book_params)
  
    if params[:book][:borrowed] == "1" && params[:borrower].present?
      borrower_data = params.require(:borrower).permit(:first_name, :last_name, :phone)
      borrower = Borrower.find_or_create_by(borrower_data)
      @book.borrower = borrower
    else
      @book.borrower = nil
      @book.due_date = nil
    end
  
    if @book.save
      redirect_to @book, notice: "Libro creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  def update
    @book = Book.find(params[:id])
  
    if params[:book][:borrowed] == "1" && params[:borrower].present?
      borrower_data = params.require(:borrower).permit(:first_name, :last_name, :phone)
      borrower = Borrower.find_or_create_by(borrower_data)
      @book.borrower = borrower
    else
      @book.borrower = nil
      @book.due_date = nil
    end
  
    if @book.update(book_params)
      redirect_to books_path, notice: "Libro aggiornato!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Libro eliminato con successo.", status: :see_other
  end

  def export_excel
    @books = Book.all
  
    # Applica i filtri se presenti
    if params[:query].present?
      @books = @books.where(
        "title ILIKE ? OR author ILIKE ? OR publisher ILIKE ? OR genre ILIKE ? OR CAST(publication_year AS TEXT) ILIKE ?",
        *Array.new(5, "%#{params[:query]}%")
      )
    end
  
    if params[:borrowed] == "1"
      @books = @books.where(borrowed: true)
    end
  
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=catalogo_filtrato.xlsx"
      }
    end
  end
  

  def export_pdf
    @books = Book.all
  
    # Applica filtro ricerca (query)
    if params[:query].present?
      q = "%#{params[:query]}%"
      @books = @books.where(
        "title ILIKE ? OR author ILIKE ? OR publisher ILIKE ? OR genre ILIKE ? OR CAST(publication_year AS TEXT) ILIKE ?", 
        q, q, q, q, q
      )
    end
  
    # Applica filtro prestito (solo se checkbox selezionato)
    if params[:borrowed] == "1"
      @books = @books.where(borrowed: true)
    end
  
    # Crea il PDF
    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
    pdf.text "Catalogo Libri Filtrato", size: 24, style: :bold, align: :center
    pdf.move_down 20
  
    # Intestazione tabella
    data = [["Titolo", "Autore", "Editore", "Genere", "Anno", "ISBN", "Prestato"]]
  
    # Righe dei libri
    @books.each do |book|
      data << [
        book.title,
        book.author,
        book.publisher,
        book.genre,
        book.publication_year,
        book.isbn,
        book.borrowed ? "Sì" : "No"
      ]
    end
  
    # Inserisce tabella
    pdf.table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { size: 12 })
  
    # Invio PDF al browser
    send_data pdf.render, filename: "catalogo_libri_filtrato.pdf", type: "application/pdf", disposition: "inline"
  end
  

  def import
    file = params[:file]
    if file.nil?
      redirect_to books_path, alert: "Nessun file selezionato."
      return
    end

    xlsx = Roo::Spreadsheet.open(file.path)
    sheet = xlsx.sheet(0)

    sheet.each_with_index(title: 'TITOLO', author: 'AUTORE', publisher: 'EDITORE', genre: 'GENERE', publication_year: 'ANNO') do |row, index|
      next if index == 0 || row[:title].blank?

      year = row[:publication_year].to_s.strip
      parsed_year = year.match?(/^\d{4}$/) ? year.to_i : nil

      Book.create(
        title: row[:title],
        author: row[:author],
        publisher: row[:publisher],
        genre: row[:genre],
        publication_year: parsed_year,
        borrowed: false
      )
    end

    redirect_to books_path, notice: "Importazione completata con successo."
  end


  def borrowed_list
    @borrowed_books = Book.includes(:borrower).where(borrowed: true).where.not(borrower_id: nil)
  end

  

  private

def set_book
  @book = Book.find(params[:id])
end

def book_params
  params.require(:book).permit(
    :title, :author, :publisher, :genre, :publication_year, :isbn, :borrowed, :due_date,
    :borrower_first_name, :borrower_last_name, :borrower_phone
  )
end

  
  
end
