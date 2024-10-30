class Book
  attr_accessor :title, :author, :publication_year
  attr_reader :id, :errors

  BOOKS = []

  @@id = 0

  def initialize(params)
    @params = params
    @id = if params[:id].present?
        params[:id]
      else
        @@id += 1
      end

    @title = params[:title]
    @author = params[:author]
    @publication_year = params[:publication_year]

    @errors = []
  end

  def self.all
    BOOKS
  end

  def self.find(id)
    book = BOOKS.find { |book| book[:id].to_i == id.to_i }

    self.new(book) if book.present?
  end

  def save
    if valid?
      BOOKS << data
      true
    else
      false
    end
  end

  def update(new_params)
    @params = @params.merge(new_params.to_h.symbolize_keys)

    @params.to_h.symbolize_keys.each do |k, v|
      instance_variable_set(:"@#{k}", v)
    end

    if valid?
      index = book_index(self)
      BOOKS[index] = @params

      self
    else
      false
    end
  end

  def destroy
    BOOKS
      .delete_if { |book| book[:id] == id }
      .size == 1
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

  def book_index(book)
    BOOKS.find_index { book }
  end

  def data
    {
      id: id.to_i,
      title: title,
      author: author,
      publication_year: publication_year.to_i,
    }
  end
end
