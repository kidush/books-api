class BooksController < ApplicationController
  def index
    render json: Book.all
  end

  def create
    @book = Book.new(params[:title], params[:author], params[:publication_year])
    @book.save

    render json: @book
  end
end
