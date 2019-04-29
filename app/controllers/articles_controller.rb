class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :is_admin?,except: [:index,:show]
  before_action :set_article,except: [:index,:new,:create]
  
  def index
    @articles = Article.all
  end
  
  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      flash[:info] = "Article Created!."
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      flash[:info] = "Article updated!."
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end
  
  def show
    @comments = @article.parent_replies.paginate(page: params[:page], per_page: 5)
  end
  
  def destroy
    @article.destroy
    flash[:success] = "Article deleted successfully!"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def is_admin?
    unless admin_user
      flash[:danger] = "User unauthorised!"
      redirect_to root_url
    end
  end
  
  def article_params
    params.require(:article).permit(:title,:content,:attachment)
  end
  
  def set_article
    @article = Article.find(params[:id])
  end
end
