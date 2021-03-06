class PostsController < ApplicationController
	before_action :find_posts , only: [:show,:edit,:update,:destroy]
    before_action :authenticate, only: [:admin, :new, :create, :edit, :update, :destroy]
	def index
		@posts=Post.all
		if params[:category].blank? 
			@post=Post.all.order("created at DESC")
		else 
			@category_id = Category.find_by(name: params[:category]).id
			@post = Post.where(category_id: @category_id).order("created at DESC")
		end
	end

	def show
	end

	def new
		@post=Post.new
	end 

	def create
		@post=Post.new(post_params)
		if @post.save
			flash[:success]= "the post was created!"
			redirect_to @post
		else
			render 'new'
		end
	end

	def update
		if @post.update(post_params)
			redirect_to @post , notice:"the past was successfully updated!"
		else 
			render 'edit'
		end
	end

	def destroy
		if @post.destroy
			redirect_to root_path , notice: "successfully destroyed!"
		end
	end 
 def authenticate
   authenticate_or_request_with_http_basic do |username, password|
   admin_username = Rails.application.secrets.admin_username
   admin_password = Rails.application.secrets.admin_password
   username == admin_username && password == admin_password 
   session[:admin] = true if (username == admin_username && password == admin_password)
  end
 end
   def admin 
   	redirect_to root_path if authenticate
   end

	private
	def post_params
		params.require(:post).permit(:title, :content , :category_id, :image)
	end
	def find_posts
		@post = Post.find(params[:id])
	end 
end

