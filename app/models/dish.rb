class Dish < ApplicationRecord
  belongs_to :restaurant
  enum dish_type: [:european, :pan_asian, :wok, :non_alcohol_drink, :alcohol_drink, :burger]
end
