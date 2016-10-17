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
	@users = User.all
	@posts = Post.all.reverse
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

get "/account-settings" do
	@current_user = User.find(session[:user_id])
	erb :account_settings
end

post "/update-account" do
	@current_user = User.find(session[:user_id])
	@current_user.update_columns(first_name: params[:first_name], 
								   						 last_name: params[:last_name], 
								  						 email: params[:email],
								   						 password: params[:password])
	redirect "/account-settings"
end

post "/delete-account" do
	@current_user = User.find(session[:user_id])
	@current_user.destroy
	redirect "/"
end

get "/sign-out" do
	p session
	session.clear
	p session
	redirect "/"
end

post "/post-blog" do
	Post.create(user_id: session[:user_id],
							title: params[:title],
							message: params[:message])
	redirect "/home"
end

get "/profile" do
	@current_user = User.find(session[:user_id])
	@posts = @current_user.posts.reverse
	erb :profile
end








