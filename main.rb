require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "./models"
set :database, "sqlite3:micro_blogging_app.sqlite3"

get "/" do
	erb :index
end