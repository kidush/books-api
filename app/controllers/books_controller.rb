class BooksController < ApplicationController
  before_action :set_book, only: %w[show update]

  def index
    render json: Book.all
  end

  def create
    @book = Book.new(params[:title], params[:author], params[:publication_year])

    if @book.save
      render json: @book
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @book.to_json
  end

  def update
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
