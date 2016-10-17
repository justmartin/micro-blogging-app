require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "./models"
require "sinatra/flash"
set :database, "sqlite3:micro_blogging_app.sqlite3"
enable :sessions
set :sessions, true

get "/" do
	erb :index
end

get "/home" do
	erb :home
end

get "/sign_up" do
	erb :sign_up
end

post "/sign-in" do
	@user = User.where(email: params[:email], password: params[:password]).first

	if @user.try(:password) == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "Sign in successful!"
		redirect "/home"
	else
		flash[:alert] = "Sign in failed. If you don't have an account, Sign Up!"
	end
end

post "/sign-up" do
	@user = User.create(params)
	flash[:notice] = "Thanks for signing up! You can now login"
	redirect "/"
end