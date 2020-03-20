# frozen_string_literal: true

class Format < ApplicationRecord
  include Cachable

  FORMATS_JSON_PATH = Rails.root.to_s + "/data/formats.json"
  FORMATS = JSON.parse(File.read(FORMATS_JSON_PATH)).freeze

  ALL_FORMATS = [
    FORMATS.map do |e|
      {
        name: e["name"],
        id: e["id"],
        sort_by: e["sort_by"],
        sort_by_second: e["sort_by_second"],
        expected_solve_count: e["expected_solve_count"],
        trim_fastest_n: e["trim_fastest_n"],
        trim_slowest_n: e["trim_slowest_n"],
      }
    end
  ].flatten.map { |d| Format.new(d) }.freeze
end
