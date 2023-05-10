# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  def reset_web_table
    seed_sql = File.read('spec/seeds/music_library.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library-web' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_web_table
  end


  get '/' do 
    return erb(:home_page)
  end

  post '/albums' do 
    repo = AlbumRepository.new

    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]
    @album_title = new_album.title

    repo.create(new_album)
    return erb(:album_created)
  end

  get '/albums/new' do 
    return erb(:add_album)
  end

  post '/artists' do 
    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    @artist_name = new_artist.name

    repo.create(new_artist)
    return erb(:artist_created)
  end

  get '/artists/new' do 
    return erb(:add_artist)
  end

  # get '/albums' do
  #   repo = AlbumRepository.new
  #   albums = repo.all

  #   response = albums.map { |album| album.title }.join(", ")
  #   return response
  # end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
  
    return erb(:album_list)
  end

  get '/message' do 
    return "Lovely dadda schweety!!<3"
  end

  get '/artists' do
    repo = ArtistRepository.new

    @artists = repo.all
  
    return erb(:artists_list)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album_index)
  end

  get '/artists/:id' do |id|
    # @id = params[:id]
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(params[:id])
    

    return erb(:artist_index)
  end
end