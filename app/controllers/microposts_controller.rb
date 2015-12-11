class MicropostsController < ApplicationController
  # ログインしていない場合はcreateメソッドを実行せず、/loginにリダイレクト
  before_action :logged_in_user
  before_action :set_micropost, only: [:destroy, :repost, :unrepost]

  def create
    # build:モデルオブジェクトを生成。newメソッドの別名。
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to request.referrer || root_url
    else
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
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
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # request.referrer:該当ページに遷移する直前に閲覧していたページのURL
    redirect_to request.referrer || root_url
  end

  def repost
    micropost = current_user.microposts.build(content: @micropost.content)
    if micropost.save
      repost = @micropost.reposts.build(repost_micropost_id: micropost.id, micropost_id: @micropost.id)
      if repost.save
        flash[:success] = "Micropost reposted!"
      end
    end
    redirect_to request.referrer || root_url
  end

  def unrepost
    return redirect_to root_url unless Repost.exists?(:repost_micropost_id => @micropost.id)
    Repost.find_by(repost_micropost_id: @micropost.id).destroy
    @micropost.destroy
    flash[:success] = "Micropost unreposted"
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
