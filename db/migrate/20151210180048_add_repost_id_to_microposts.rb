class AddRepostIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :repost_id, :integer
  end
end
