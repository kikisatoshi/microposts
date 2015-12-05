class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def logged_in_user
    unless logged_in?
      # アクセスしようとしたURLを保存
      store_location
      flash[:danger] = "Please log in"
      # _pathをつけた場合は相対パス、_urlをつけた場合は「http://〜」で始まる絶対URLになる
      redirect_to login_url
    end
  end
end
