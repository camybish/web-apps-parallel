require "rack/test"
require_relative '../../app'
require 'pg'
require 'album_repository'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }



  before(:each) do 
    reset_app_table
  end
  

  context 'GET /albums' do 
    it 'should display all albums' do
      response = get('/albums')
    
      expect(response.status).to eq(200)
      expect(response.body).to include('Title: Super Trouper')
      expect(response.body).to include('More info</button>')
      expect(response.body).to include('Folklore <br>')

    end
  end

  context 'GET /artists' do 
    it 'should display all artists' do
      response = get('/artists')
      
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it 'should create a new album' do
      # Assuming the post with id 1 exists.
      response = post('/albums', title:'Voyage', release_year:'2022', artist_id:'2')


      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.body).to include('Voyage')
    end

    it 'should create a new album from a text box' do 
      response = post('/albums/new', title:'ABBA Live', release_year: '1986', artist_id: '2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>album added: ABBA Live</h1>')
    end

    it 'should create a new album from a text box - different album' do 
      response = post('/albums/new', title:'Reputation', release_year: '2017', artist_id: '3')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>album added: Reputation</h1>')
    end
  end

  context "POST /artists" do
    it 'should create a new artist' do
      # Assuming the post with id 1 exists.
      response = post('/artists', name:'Wild nothing', genre:'Indie')


      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.body).to eq("Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing")
    end
  end

  context 'GET /artists/new' do
    it 'should show a confirmation message when an artist is entered' do 
      response = post('/artist', name: "Pharoah Sanders", genre: "Jazz")

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Artist: Pharoah Sanders successfully added!</h1>')
    end
  end

  context "GET /albums/1" do
    it 'should create a new artist' do
      response = get('/albums/1')


      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('1989')
      expect(response.body).to include('Pixies')
    end
  end
end
