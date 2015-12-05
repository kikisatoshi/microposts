class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # flash[キー]:簡単なメッセージを画面に表示
      flash[:success] = "Welcom to the Sample App!"
      # @user＝URLヘルパ（user_path(@user)）＝URL（/users/:id）
      # redirect_to＝HTTPメソッド（GET）＝アクション（show）
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    # ブラウザのフォームから送信されたパラメータは、コントローラのparamsメソッドで取得できる。
    # paramsに:userというキーが存在するか検証し、存在する場合はparams[:user]のうち
    # キーが:nameなどの指定した値のみ受け取るようにフィルタリング。
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
