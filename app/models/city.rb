class City < ActiveRecord::Base
  set_table_name(:city)
  set_primary_key(:city_id)

  belongs_to :country
  has_many :addresses
  has_many :stores, through: :addresses

  def self.movie_rental_counts
    self.select('city.*, COUNT(rental.rental_id) AS rental_count')
        .joins(:stores => [{ :inventories => [:rentals] }])
        .group('city.city_id')
        .order('COUNT(rental.rental_id) DESC')
  end
end