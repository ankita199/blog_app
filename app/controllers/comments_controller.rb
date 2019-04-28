class CommentsController < ApplicationController
  before_action :load_article
  
  def index
    if params[:parent_comment_id].present?
      @comments = Comment.replies(params[:parent_comment_id], params[:parent_page])
      params[:parent_page] = @comments.next_page
    else
      @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)
    end
  end
  
  def new
    @parent_comment_id = params[:parent_comment_id]
  end
  
  def create
    @comment = Comment.create(comment_params)
    redirect_to article_path(@article)
  end
  
  private
  
  def load_article
    @article = Article.find(params[:article_id])
  end
  
  def comment_params
    params.require(:comment).permit(:content,:user_id,:article_id,:parent_comment_id)
  end
end