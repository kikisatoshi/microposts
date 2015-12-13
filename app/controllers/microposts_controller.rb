class MicropostsController < ApplicationController
  # ログインしていない場合はcreateメソッドを実行せず、/loginにリダイレクト
  before_action :logged_in_user
  before_action :set_micropost, only: [:destroy, :repost, :unrepost, :favorite,
                                       :unfavorite]
  def index
    redirect_to request.referrer || root_url
  end

  def create
    # build:モデルオブジェクトを生成。newメソッドの別名。
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      if locale == :ja
        flash[:success] = "マイクロポストがポストされました。"
      else
        flash[:success] = "Micropost created!"
      end
      redirect_to root_url
    else
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc).page(params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    if Repost.exists?(:micropost_id => @micropost.id)
      for repost in Repost.where(micropost_id: @micropost.id)
        Micropost.find(repost.repost_micropost_id).destroy
        repost.destroy
      end
    end
    if Favorite.exists?(:micropost_id => @micropost.id)
      for favorite in Favorite.where(micropost_id: @micropost.id)
        favorite.destroy
      end
    end
    @micropost.destroy
    if locale == :ja
      flash[:success] = "マイクロポストが削除されました。"
    else
      flash[:success] = "Micropost deleted."
    end
    # request.referrer:該当ページに遷移する直前に閲覧していたページのURL
    redirect_to request.referrer || root_url
  end

  def repost
    micropost = current_user.microposts.build(content: @micropost.content)
    if micropost.save
      repost = @micropost.reposts.build(repost_micropost_id: micropost.id)
      if repost.save
        if locale == :ja
          flash[:success] = "マイクロポストがリポストされました。"
        else
          flash[:success] = "Micropost reposted."
        end
      end
    end
    redirect_to request.referrer || root_url
  end

  def unrepost
    return redirect_to root_url unless Repost.exists?(:repost_micropost_id => @micropost.id)
    Repost.find_by(repost_micropost_id: @micropost.id).destroy
    @micropost.destroy
    if locale == :ja
      flash[:success] = "リポストが解除されました。"
    else
      flash[:success] = "Micropost unreposted."
    end
    redirect_to request.referrer || root_url
  end

  def favorite
    favorite = current_user.favorites.build(micropost_id: @micropost.id)
    if favorite.save
      if locale == :ja
        flash[:success] = "お気に入りに追加されました。"
      else
        flash[:success] = "Micropost added to favorites."
      end
    end
    redirect_to request.referrer || root_url
  end

  def unfavorite
    return redirect_to root_url unless Favorite.exists?(:micropost_id => @micropost.id)
    for favorite in Favorite.where(micropost_id: @micropost.id)
      if current_user.id == favorite.user_id
        favorite.destroy
        if locale == :ja
          flash[:success] = "お気に入りから削除されました。"
        else
          flash[:success] = "Micropost deleted from favorites."
        end
      end
    end
    redirect_to request.referrer || root_url
  end

  private
  def set_micropost
    if Micropost.exists?(:id => params[:id])
      @micropost = Micropost.find(params[:id])
    else
      redirect_to request.referrer || root_url
    end
  end

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
