class Favorite < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
