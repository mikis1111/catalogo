class BorrowersController < ApplicationController
  def new
    @borrower = Borrower.new
    @return_to_book_id = params[:return_to_book_id]
  end
  

  
# app/controllers/borrowers_controller.rb
def create
@borrower = Borrower.new(borrower_params)
if @borrower.save
  if params[:return_to_book_id].present?
    redirect_to edit_book_path(params[:return_to_book_id]), notice: "Lettore aggiunto con successo"
  else
    redirect_to books_path, notice: "Lettore creato"
  end
else
  @return_to_book_id = params[:return_to_book_id]
  render :new, status: :unprocessable_entity
end
end


  
  private
  
  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :phone)
  end
  
end
