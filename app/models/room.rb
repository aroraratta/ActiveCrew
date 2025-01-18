class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, through: :entries

  # users#showにて新しいメッセージがあるDMルームをソートするため必要
  default_scope { order(created_at: :desc) }
end
