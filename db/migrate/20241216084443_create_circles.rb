class CreateCircles < ActiveRecord::Migration[6.1]
  def change
    create_table :circles do |t|
      t.references :prefecture, foreign_key: true
      t.references :city, foreign_key: true
      t.integer :owner_id
      t.string :circle_name, null: false
      t.text :circle_introduction

      t.timestamps
    end

    add_index :circles, :circle_name,         unique: true
    add_index :circles, :circle_introduction, length: 191
  end
end
