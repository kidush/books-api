require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    it "returns a list of books" do
      book1 = Book.new("my book 1", "Author", 2024)
      book2 = Book.new("my book 2", "Author", 2022)

      book1.save
      book2.save

      get "/books"

      parsed_body = JSON.parse(response.body)

      expect(parsed_body.size).to eq 2

      expect(parsed_body[0]["title"]). to eq("my book 1")
    end
  end

  describe "POST /books/:id" do
    context "when a valid data is passed" do
      it "creates a book" do
        expect { 
          post "/books", params: { title: "My book", author: "Author", publication_year: 2024 }
        }. to change(Book.all, :size).by(1)
      end

      it "returns a status of ok" do
        post "/books", params: { title: "My book", author: "Author", publication_year: 2024 }

        expect(response).to have_http_status :ok 
      end
    end
  end
end
