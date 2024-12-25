class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.references :prefecture, null: false, foreign_key: true
      t.string :city_name, null: false

      t.timestamps
    end
  end
end
