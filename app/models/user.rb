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
  # データベースに安全にハッシュ化（暗号化）されたpassword_digestを保存
  # passwordとpassword_confirmationをモデルに追加して、パスワードの確認が一致するか検証
  # パスワードが正しいときに、ユーザーを返すauthenticateメソッドを提供
  has_secure_password
  # ユーザーは複数の投稿を持てる。buildメソッドを生成。
  has_many :microposts
end
