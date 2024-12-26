class Event < ApplicationRecord
  belongs_to :circle, optional: true
end
