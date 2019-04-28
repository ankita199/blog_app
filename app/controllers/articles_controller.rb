class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @articles = current_user.articles
  end
  
  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)
    @article.attachment.attach(params[:article][:attachment])
    if @article.save
      flash[:info] = "Article Createdt."
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
  end
  
  def show
    @article = current_user.articles.find(params[:id])
    @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)

  end
  
  def load_comments
    @article = current_user.articles.find(params[:id])
    if params[:parent_comment_id].present?
      @comments = Comment.replies(params[:parent_comment_id], params[:parent_page])
    else
      @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)
    end
         puts "=============="+@comments.count.to_s

  end
  
  private
  
  def article_params
    params.require(:article).permit(:title,:content)
  end
end
