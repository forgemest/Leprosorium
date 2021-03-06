#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db

  @db.execute 'create table if not exists Posts
  (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content TEXT
  )'

end

get '/' do

  @results = @db.execute 'select * from Posts order by id desc'

	erb :index
end


get '/new' do
	erb :new
end

post '/new' do

    content = params[:content]

    if content.length <= 0
      @error = 'Type text'
      return erb :new
    end

    @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

    redirect to '/'
end

get '/details/:post_id' do
  post_id = params[:post_id]

  results = @db.execute 'select * from Posts where id = ?', [post_id]
  @row = results[0]
  erb :details
end

