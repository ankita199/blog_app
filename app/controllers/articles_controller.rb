class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def index
    @articles = Article.all
  end
  
  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)
    @article.attachment.attach(params[:article][:attachment])
    if @article.save
      flash[:info] = "Article Created!."
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.attachment.attach(params[:article][:attachment])
    if @article.update_attributes(article_params)
      flash[:info] = "Article updated!."
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end
  
  def show
    @article = Article.find(params[:id])
    @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)
  end
  
  def destroy
    if admin_user
      @article = Article.find(params[:id])
      @article.destroy
      flash[:success] = "Article deleted successfully!"
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "User unauthorised!"
    end
  end
  
  def load_comments
    @article = Article.find(params[:id])
    if params[:parent_comment_id].present?
      @comments = Comment.replies(params[:parent_comment_id], params[:parent_page])
      params[:parent_page] = @comments.next_page
    else
      @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)
    end
  end
  
  private
  
  def article_params
    params.require(:article).permit(:title,:content)
  end
end
