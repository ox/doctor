class Event < ActiveRecord::Base
  belongs_to :routine
  serialize :returned, Hash
end
