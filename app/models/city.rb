class City < ApplicationRecord
  belongs_to :prefecture
  has_many :circles, dependent: :destroy
end
