# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

class CustomSeeds
  class << self
    def call
      create_day_types
    end

    def create_day_types
      days = ["Weekdays","Weekends","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
      days.each { |d|  Spree::DayType.create(name: d) }
    end
  end
end

CustomSeeds.call
