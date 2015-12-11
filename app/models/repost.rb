class Repost < ActiveRecord::Base
  belongs_to :micropost

  validates :micropost_id, presence: true
  validates :repost_micropost_id, presence: true
end
