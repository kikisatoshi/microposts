class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      # user_idという外部キーをカラムに追加。index:user_idに対してインデックスを作成。
      # foreign_key:外部キー制約(指定したカラムに格納できる値を他のテーブルに格納されている値だけに限定するもの)を設定。
      t.references :user, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
      # 複合インデックス(テーブルの複数のカラムを組み合わせて１つのインデクスとするもの)
      t.index [:user_id, :created_at]
    end
  end
end
