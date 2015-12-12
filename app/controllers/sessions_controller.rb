class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to current_user
    end
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      if locale == :ja
        flash[:info] = "#{@user.name}さんがログインしました。"
      else
        flash[:info] = "logged in as #{@user.name}."
      end
      # UsersControllerのshowアクションへリダイレクト
      redirect_to @user
    else
      if locale == :ja
        flash[:danger] = 'メールアドレスとパスワードが不正な組み合わせです。'
      else
        flash[:danger] = 'invalid email/password combination'
      end
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
