class PostsController < ApplicationController
	before_action :find_posts , only: [:show,:edit,:update,:destroy]
	def index
		@post=Post.all
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
	def destroy
		if @post.destroy
			redirect_to root_path , notice: "successfully destroyed!"
	end 
	private
	def post_params
		params.require(:post).permit(:title, :content , :category_id)
	end
	def find_posts
		@post = Post.find(params[:id])
	end 
end
