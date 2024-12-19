class CreateCircleUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :circle_users do |t|
      t.references :user, foreign_key: true
      t.references :circle, foreign_key: true

      t.timestamps
    end
  end
end
