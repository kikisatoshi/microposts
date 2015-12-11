class RemoveColumsToMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :repost_user_id, :integer
    remove_column :microposts, :reposted_id, :integer
  end
end
