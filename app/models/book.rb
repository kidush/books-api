class Book
  attr_accessor :title, :author, :publication_year
  attr_reader :id, :errors

  BOOKS = []

  @@id = 0

  def initialize(title = nil, author = nil, publication_year = nil)
    @@id += 1
    @id = @@id
    @title = title
    @author = author
    @publication_year = publication_year

    @errors = []
  end

  def self.all
    BOOKS
  end

  def self.find(id)
    BOOKS.find { |book| book[:id] == id.to_i }
  end

  def save
    if valid?
      BOOKS << data
      true
    else
      false
    end
  end

  def valid?
    validate_title
    validate_author
    validate_publication_year

    @errors.empty?
  end

  def validate_title
    return true unless title.blank?

    @errors << { title: "can't be blank" }
    false
  end

  def validate_author
    return true unless author.blank?

    @errors << { author: "can't be blank" }
    false
  end

  def validate_publication_year
    return true unless publication_year.blank?

    @errors << { publication_year: "can't be blank" }
    false
  end

  private

  def data
    {
      id: id.to_i,
      title: title,
      author: author,
      publication_year: publication_year.to_i
    }
  end
end
