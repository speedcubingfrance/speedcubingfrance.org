# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Event::ALL_EVENTS.each(&:save!)
Format::ALL_FORMATS.each(&:save!)
Region::ALL_REGIONS.each(&:save!)
Department::ALL_DEPARTMENTS.each(&:save!)
