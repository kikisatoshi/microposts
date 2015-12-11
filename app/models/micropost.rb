class Micropost < ActiveRecord::Base
  # 投稿は特定の1人のユーザーのもの
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  # リポスト関係
  has_many :reposts
end
