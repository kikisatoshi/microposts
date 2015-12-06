class User < ActiveRecord::Base
  # downcase:アルファベットを小文字にする
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  # メールアドレスの正規表現パターンを定義
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # uniqueness:trueで対象のフィールドがデータベース内で一意。case_sensitive:falseで大文字小文字の差を無視。
                    uniqueness: { case_sensitive: false }

  validates :location, length: { maximum: 50 }
  validates :profile, length: { maximum: 160 }

  # データベースに安全にハッシュ化（暗号化）されたpassword_digestを保存
  # passwordとpassword_confirmationをモデルに追加して、パスワードの確認が一致するか検証
  # パスワードが正しいときに、ユーザーを返すauthenticateメソッドを提供
  has_secure_password

  # ユーザーは複数の投稿を持てる。buildメソッドを生成。
  has_many :microposts

  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed

  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
end
