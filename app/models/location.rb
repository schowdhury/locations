class Location < ActiveRecord::Base
  attr_accessible :lat, :lon, :description
end
