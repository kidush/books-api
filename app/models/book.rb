class Book
  attr_accessor :title, :author, :publication_year

  BOOKS = []

  def initialize(title, author, publication_year)
    @title = title
    @author = author
    @publication_year = publication_year
  end

  def self.all
    BOOKS
  end

  def save
    BOOKS << book_data
  end

  private

  def book_data
    {
      title: @title,
      author: @author,
      publication_year: @publication_year
    }
  end
end
