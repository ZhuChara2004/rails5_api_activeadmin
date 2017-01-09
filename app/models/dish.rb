class Dish < ApplicationRecord
  belongs_to :restaurant
  enum type: [:european, :pan_asian, :wok, :non_alcohol_drink, :alcohol_drink]
end
