class ArticlesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show, :notify_friend]

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.all
    @articles = Article.page(params[:page]).per(10)
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = current_user.articles.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = current_user.articles.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => t('articles.create_success')) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = current_user.articles.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => t('articles.update_success')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
  def notify_friend
    @article = Article.find(params[:id])
    Notifier.email_friend(@article, params[:name], params[:email]).deliver
    redirect_to @article, :notice => t('articles.notify_friend_success')
  end  

=begin
  def vote_up
    @article = Article.find(params[:id])
    @user = User.find(current_user.id)
    @vote = @article.votes.create(params[:article])
    @vote.user = @user
    @vote.article = @article
    @vote.score = 1
    respond_to do |format|
      if @vote.save!
        format.html {redirect_to(articles_path)}
      else
        format.html {redirect_to(articles_path)}
      end
    end 
  end


  def vote_up
    @article = Article.find(params[:id])
    @user = User.find(current_user.id)
    @vote = @article.votes.create(params[:article])
    @vote.user = @user
    @vote.article = @article
    @vote.score = 1
    @article_votes = 3
    puts article_votes: #{@article_votes}
      begin
        current_user.vote_for(@article = Article.find(params[:id]))
        redirect_to :back
      rescue ActiveRecord::RecordInvalid
        redirect_to :back
      end
  end
=end

   def vote_up
     begin
       @article = Article.find(params[:id])
       @vote = current_user.votes.find_by_voteable_id(@article.id)
       if @vote == nil
       current_user.vote_for(@article = Article.find(params[:id]))
       redirect_to :back
       else
       @vote.delete
       current_user.vote_for(@article = Article.find(params[:id]))
       redirect_to :back
       end
     rescue ActiveRecord::RecordInvalid
     end
   end
   
   def vote_down
      begin
        @article = Article.find(params[:id])
        @vote = current_user.votes.find_by_voteable_id(@article.id)
        if @vote == nil
        current_user.vote_for(@article = Article.find(params[:id]))
        redirect_to :back
        else
        @vote.delete
        current_user.vote_against(@article = Article.find(params[:id]))
        redirect_to :back
        end
#!        render :nothing => true, :status => 200
      rescue ActiveRecord::RecordInvalid
#!  render :nothing => true, :status => 404
      end
    end

end
