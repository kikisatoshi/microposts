class DropTableRepost < ActiveRecord::Migration
  def change
    drop_table :reposts
  end
end
