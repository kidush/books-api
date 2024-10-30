require "rails_helper"

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    it "returns a list of books" do
      data = { title: "My book 1", author: "Author", publication_year: 2024 }
      book1 = Book.new(data)
      book2 = Book.new(data.merge({ title: "My book 2" }))

      book1.save
      book2.save

      get "/books"

      parsed_body = JSON.parse(response.body)

      expect(parsed_body.size).to eq 2

      expect(parsed_body[0]["title"]).to eq("My book 1")
    end
  end

  describe "POST /books/:id" do
    context "when a valid data is passed" do
      it "creates a book" do
        expect {
          post "/books", params: { title: "My book", author: "Author", publication_year: 2024 }
        }.to change(Book.all, :size).by(1)
      end

      it "returns a status of ok" do
        post "/books", params: { title: "My book", author: "Author", publication_year: 2024 }

        expect(response).to have_http_status :ok
      end
    end

    context "when an invalid book is passed" do
      context "without a title" do
        it "returns a unprocessable_entity status" do
          post "/books", params: { title: "", author: "Author", publication_year: 2024 }

          expect(response).to have_http_status :unprocessable_entity
        end

        it "returns a messsage of can't title can't be blank" do
          post "/books", params: { title: "", author: "Author", publication_year: 2024 }

          parsed_body = JSON.parse(response.body)
          expect(parsed_body["errors"][0]["title"]).to eq("can't be blank")
        end
      end

      context "without an author" do
        it "returns a unprocessable_entity status" do
          post "/books", params: { title: "My book", author: "", publication_year: 2024 }

          expect(response).to have_http_status :unprocessable_entity
        end

        it "returns a messsage of can't author can't be blank" do
          post "/books", params: { title: "My book", author: "", publication_year: 2024 }

          parsed_body = JSON.parse(response.body)
          expect(parsed_body["errors"][0]["author"]).to eq("can't be blank")
        end
      end

      context "without the publication_year" do
        it "returns a unprocessable_entity status" do
          post "/books", params: { title: "My book", author: "Author" }

          expect(response).to have_http_status :unprocessable_entity
        end

        it "returns a messsage of publication_year can't be blank" do
          post "/books", params: { title: "My book", author: "Author" }

          parsed_body = JSON.parse(response.body)
          expect(parsed_body["errors"][0]["publication_year"]).to eq("can't be blank")
        end
      end

      context "with two or more parameters missing" do
        it "returns an array of error messages" do
          post "/books", params: { title: "My book", author: "" }

          parsed_body = JSON.parse(response.body)

          expect(parsed_body["errors"][0]["author"]).to eq("can't be blank")
          expect(parsed_body["errors"][1]["publication_year"]).to eq("can't be blank")
        end
      end
    end
  end

  describe "GET /books/:id" do
    context "When a valid id is passed" do
      it "returns the book" do
        stub_const("Book::BOOKS", [
          { id: 1, title: "Mocked book 1", author: "Mock author 1", publication_year: 2023 },
          { id: 2, title: "Mocked book 2", author: "Mock author 2", publication_year: 2024 },
        ])

        get "/books/1"
        parsed_body = JSON.parse(response.body)

        expect(parsed_body["title"]).to eq("Mocked book 1")
        expect(parsed_body["author"]).to eq("Mock author 1")
        expect(parsed_body["publication_year"]).to eq(2023)
      end
    end
  end

  describe "PUT /books/:id" do
    context "with a valid book" do
      it "updates a book in the list of books" do
        stub_const("Book::BOOKS", [
          { id: 1, title: "Mocked book 1", author: "Mock author 1", publication_year: 2023 },
          { id: 2, title: "Mocked book 2", author: "Mock author 2", publication_year: 2024 },
        ])

        put "/books/1", params: { title: "My new book 1" }
        parsed_body = JSON.parse(response.body)

        expect(parsed_body["title"]).to eq("My new book 1")
        expect(parsed_body["author"]).to eq("Mock author 1")
        expect(parsed_body["publication_year"]).to eq(2023)
      end
    end
  end

  describe "DELETE /books/:id" do
    context "with a valid book id passed" do
      it "deletes the book" do
        stub_const("Book::BOOKS", [
          { id: 1, title: "Mocked book 1", author: "Mock author 1", publication_year: 2023 },
          { id: 2, title: "Mocked book 2", author: "Mock author 2", publication_year: 2024 },
        ])

        delete "/books/1"
        get "/books"

        parsed_body = JSON.parse(response.body)
        expect(parsed_body.size).to eq 1
        expect(parsed_body[0]["title"]).to eq("Mocked book 2")
      end
    end
  end
end
