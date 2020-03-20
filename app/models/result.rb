class Result < ApplicationRecord
  include Resultable

  belongs_to :user
  validates_presence_of :user
  delegate :country, to: :user

  def serializable_hash(options = nil)
    {
      id: id,
      competition_id: online_competition_id,
      event_id: event_id,
      format_id: format_id,
      wca_id: user.wca_id,
      user_id: user.id,
      attempts: [value1, value2, value3, value4, value5],
      best: best,
      average: average,
    }
  end
end
