class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :authorize!, only: [:edit, :update]

  def index
    redirect_to root_url
  end

  def show
    # ユーザーに紐付いたマイクロポストを作成日時が新しいものから取得し、@micropostsに代入
    # page(params[:page]はページネーション用
    @microposts = @user.microposts.order(created_at: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # flash[キー]:簡単なメッセージを画面に表示
      if locale == :ja
        flash[:success] = "マイクロポストへようこそ！"
      else
        flash[:success] = "Welcom to the Microposts!"
      end
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
      if locale == :ja
        flash[:success] = "アカウント設定が更新されました。"
      else
        flash[:success] = "Your settings have been saved."
      end
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end

  def followings
    @followings = @user.following_users.page(params[:page])
  end

  def followers
    @followers = @user.follower_users.page(params[:page])
  end

  def show_favorites
    @favorites = @user.favorites.page(params[:page])
    @microposts = Micropost.find(@favorites.pluck("micropost_id"))
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
    if User.exists?(:id => params[:id])
      @user = User.find(params[:id])
      redirect_to root_url if current_user.nil?
    else
      redirect_to current_user
    end
  end

  def authorize!
    if @user != current_user
      if locale == :ja
        flash[:danger] = "不正なアクセスです！"
      else
        flash[:danger] = "Invalid access!"
      end
      redirect_to root_url
    end
  end
end
