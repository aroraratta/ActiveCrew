class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :circle_id
      t.string :body, null: false

      t.timestamps
    end

    add_index :posts, :body
  end
end
