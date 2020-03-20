# frozen_string_literal: true

class Event < ApplicationRecord
  include Cachable

  EVENTS_JSON_PATH = Rails.root.to_s + "/data/events.json"
  EVENTS = JSON.parse(File.read(EVENTS_JSON_PATH)).freeze

  ALL_EVENTS = [
    EVENTS.map do |e|
      {
        name: e["name"],
        id: e["id"],
        rank: e["rank"],
        preferred_format: e["preferred_format"],
      }
    end
  ].flatten.map { |d| Event.new(d) }.freeze

  # 'rank' is not reserved in postgres
  scope :official, -> { where("rank < 990") }
  scope :deprecated, -> { where("rank between 990 and 999") }

  def official?
    rank < 990
  end

  def deprecated?
    990 <= rank && rank < 1000
  end

  # See https://www.worldcubeassociation.org/regulations/#9f12
  def timed_event?
    !fewest_moves? && !multiple_blindfolded?
  end

  def fewest_moves?
    self.id == "333fm"
  end

  def multiple_blindfolded?
    self.id == "333mbf" || self.id == "333mbo"
  end
end
