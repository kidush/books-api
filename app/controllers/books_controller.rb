class BooksController < ApplicationController
  before_action :set_book, only: %w[show update]

  def index
    render json: Book.all
  end

  def create
    book = Book.new(valid_params)

    if book.save
      render json: book
    else
      render json: { errors: book.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @book
  end

  def update
    if @book.update(valid_params)
      render json: @book
    end
  end

  private

  def valid_params
    params.permit(:id, :title, :author, :publication_year)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
