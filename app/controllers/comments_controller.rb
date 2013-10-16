class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def index
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize! :create, Comment, message: "You need to be a member to create comments."
  end

  def create
    @post = Post.find(params[:post_id])
    @topic = @post.topic
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    @comment.post = @post

    authorize! :create, @comment, message: "You need to be signed in to do that."
    if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      redirect_to [@topic, @post]
    end
  end

  def show
  end

  def edit
  end
end
