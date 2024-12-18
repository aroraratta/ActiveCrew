class Prefecture < ApplicationRecord
  has_many :cities, dependent: :destroy
  has_many :circles, dependent: :destroy
end
