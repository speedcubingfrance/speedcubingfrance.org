class Result < ApplicationRecord
  include Resultable

  belongs_to :user
  validates_presence_of :user
  delegate :country, to: :user

  before_validation :set_format
  def set_format
    if event && !format_id
      self.format_id = event.preferred_format
    end
  end

  def serializable_hash(options = nil)
    {
      id: id,
      competition_id: online_competition_id,
      event_id: event_id,
      format_id: format_id,
      user: user.as_json,
      attempts: [value1, value2, value3, value4, value5],
      best: best,
      average: average,
      # This attribute is actually only set when ranking results!
      pos: self[:pos] || 0,
    }
  end
end
