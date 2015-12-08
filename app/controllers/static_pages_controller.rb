class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # Micropostクラスのインスタンスを、user_idを紐付けた状態で初期化
      # current_user.microposts.build＝Micropost.new(user_id: current_user.id)
      @micropost = current_user.microposts.build

      # includes(:user):userの情報を紐付けている。
      # これにより@feed_itemsからアイテムを取り出すたびにDBからユーザ情報を取り出さずに済む。
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
    end
  end
end
