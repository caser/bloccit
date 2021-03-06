class CommentsController < ApplicationController

  respond_to :html, :js

  before_filter :authenticate_user!

  def index
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize! :create, Comment, message: "You need to be a member to create comments."
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    @comment.post = @post
    @new_comment = Comment.new

    authorize! :create, @comment, message: "You need to be signed in to do that."
    
    if @comment.save
      flash[:notice] = "Comment was saved."
    else
      flash[:error] = "There was an error saving the comment. Please try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])
    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    
    if @comment.destroy
      flash[:notice] = "Comment was removed."
    else
      flash[:error] = "Comment couldn't be deleted. Try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end
  
end
