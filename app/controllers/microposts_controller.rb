class MicropostsController < ApplicationController
  # ログインしていない場合はcreateメソッドを実行せず、/loginにリダイレクト
  before_action :logged_in_user, only: [:create]

  def create
    # build:モデルオブジェクトを生成。newメソッドの別名。
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # request.referrer:該当ページに遷移する直前に閲覧していたページのURL
    redirect_to request.referrer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
