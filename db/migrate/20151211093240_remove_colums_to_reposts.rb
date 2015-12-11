class RemoveColumsToReposts < ActiveRecord::Migration
  def change
    remove_reference :reposts, :repost_user, index: true, foreign_key: true
    remove_reference :reposts, :reposted, index: true, foreign_key: true
  end
end
