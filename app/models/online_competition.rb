class OnlineCompetition < ApplicationRecord
  validates_presence_of :name
  validates_inclusion_of :visible, in: [true, false]

  scope :by_start_date, -> { order(start_date: :desc) }
  scope :visible, -> { where(visible: true) }

  validate :dates_are_valid
  def dates_are_valid
    return errors.add(:start_date, "Pas de date de début") unless start_date.present?
    return errors.add(:end_date, "Pas de date de fin") unless end_date.present?

    if end_date < start_date
      errors.add(:end_date, "La compétition finie avant d'avoir commencée...")
    end
  end

  def over?
    end_date < Date.today
  end

  def started?
    start_date < Date.today
  end

  def ongoing?
    started? && !over?
  end
end
