module Spree
  class StoreDayType < Spree::Base
    belongs_to :store
    belongs_to :day_type
  end
end
