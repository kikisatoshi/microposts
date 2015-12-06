class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize!, only: [:edit, :update]

  def show
    # ユーザーに紐付いたマイクロポストを作成日時が新しいものから取得し、@micropostsに代入
    @microposts = @user.microposts.order(created_at: :desc)
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

  def edit
  end

  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:info] = "基本情報を編集しました"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end

  private

  def user_params
    # ブラウザのフォームから送信されたパラメータは、コントローラのparamsメソッドで取得できる。
    # paramsに:userというキーが存在するか検証し、存在する場合はparams[:user]のうち
    # キーが:nameなどの指定した値のみ受け取るようにフィルタリング。
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :profile, :location)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize!
    if @user != current_user
      redirect_to root_url, alert: "不正なアクセスです。"
    end
  end
end
