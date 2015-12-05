module SessionsHelper
  def current_user
    # ||=:左の値がfalseかnilの場合に右の値を代入
    # メソッド中の最後の値が代入文の場合は、代入後の左の値（/users/1など）を返す
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # current_userが存在する場合はtrueを、nilの場合はfalseを返す
  def logged_in?
    !!current_user
  end

  def store_location
    # session[:forwarding_url]にリクエストのURLを代入。request.get?:requestがGETかどうか。
    session[:forwarding_url] = request.url if request.get?
  end
end
