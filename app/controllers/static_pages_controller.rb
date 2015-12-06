class StaticPagesController < ApplicationController
  def home
    # Micropostクラスのインスタンスを、user_idを紐付けた状態で初期化
    # current_user.microposts.build＝Micropost.new(user_id: current_user.id)
    @micropost = current_user.microposts.build if logged_in?
  end
end
