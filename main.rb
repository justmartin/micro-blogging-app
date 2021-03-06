require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "./models"
require "sinatra/flash"
enable :sessions
set :sessions, true

configure(:development) do
  set :database, "sqlite3:micro_blogging_app.sqlite3"
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

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
		redirect "/"
	end
end

post "/sign-up" do
	@user = User.create(params)
	flash[:notice] = "Thanks for signing up! You can now login"
	redirect "/"
end

get "/account-settings" do
	erb :account_settings
end

post "/update-account" do
	current_user.update_columns(first_name: params[:first_name], 
								   						 last_name: params[:last_name], 
								  						 email: params[:email],
								   						 password: params[:password])
	redirect "/account-settings"
end

post "/delete-account" do
	current_user.destroy
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
	@posts = current_user.posts.reverse
	erb :profile
end

get "/:user_id" do
	@user = User.find(params[:user_id])
	@posts = @user.posts.reverse
	erb :user_profile
end

post "/delete-post" do
	post = Post.find(params[:id])
	post.destroy
	redirect "/home"
end
