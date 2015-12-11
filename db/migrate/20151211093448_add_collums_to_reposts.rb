class AddCollumsToReposts < ActiveRecord::Migration
  def change
    add_reference :reposts, :repost_micropost, index: true, foreign_key: true
    add_reference :reposts, :reposted_micropost, index: true, foreign_key: true
    add_index :reposts, [:repost_micropost_id, :reposted_micropost_id], unique: true
  end
end
