require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    let(:first_author) { FactoryBot.create(:author, first_name: 'Christian', last_name: 'Romero', age:  42)} 
    let(:second_author) { FactoryBot.create(:author, first_name: 'Iliana', last_name: 'Duron', age:  41) }

    before do
      FactoryBot.create(:book, title: '1984', author: first_author)
      FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it 'create a new book' do
      expect {
        post '/api/v1/books', params: { 
          book: {title: 'The Matrix'},
          author: { first_name: 'Lana', last_name: 'Wachowski', age: 56}
        }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(JSON.parse(response.body)).to eq(
        'id'=> 1,
        'title'=> 'The Matrix',
        'author_name'=> 'Lana Wachowski',
        'author_age' => 56 
      )

    end
  end


  describe 'DELETE /books/:id' do
    let!(:book) {FactoryBot.create(:book, title: '1984', author: 'George Orwell')}
    
    it 'deletes a new book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)

    end
  end
end