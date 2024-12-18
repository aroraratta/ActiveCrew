class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.integer :prefecture_id, null: false
      t.string :city_name, null: false

      t.timestamps
    end
  end
end
