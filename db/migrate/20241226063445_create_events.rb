class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :circle, null: false, foreign_key: true
      t.string :event_title, null: false
      t.string :event_place
      t.string :event_memo
      t.datetime :start, null: false
      t.datetime :end, null: false

      t.timestamps
    end
  end
end
