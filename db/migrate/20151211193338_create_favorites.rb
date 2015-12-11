class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :micropost_id

      t.timestamps null: false
      t.index [:user_id, :created_at]
    end
  end
end
