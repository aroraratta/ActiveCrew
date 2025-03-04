class Event < ApplicationRecord
  belongs_to :circle, optional: true
  has_many :attends, dependent: :destroy
  
  validates :event_title, presence: true
  
  def attended_by?(user)
    attends.exists?(user_id: user.id)
  end

end
