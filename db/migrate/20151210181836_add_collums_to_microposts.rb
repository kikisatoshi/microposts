class AddCollumsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :repost_user_id, :integer
    add_column :microposts, :reposted_id, :integer
    remove_column :microposts, :repost_id, :integer
  end
end
