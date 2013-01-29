class Film < ActiveRecord::Base
  set_table_name(:film)
  set_primary_key(:film_id)

  has_many :roles, class_name: 'Role'
  has_many :actors, through: :roles
  has_one :film_category
  has_one :category, through: :film_category
  has_many :inventories
  has_many :stores, through: :inventories
  has_many :customers, through: :inventories

  def self.largest_casts
    self.select('*, COUNT(*) AS cast_size')
        .joins(:roles)
        .group('film.film_id')
        .order('COUNT(*) DESC')
  end

  def self.most_inventory
    self.select('*, COUNT(*) AS inventory_count')
        .joins(:inventories)
        .group('film.film_id')
        .order('COUNT(*) DESC')
  end

  def self.most_stores
    self.select('*, COUNT(DISTINCT store_id) AS store_count')
        .joins(:inventories)
        .group('film.film_id')
        .order('COUNT(DISTINCT store_id) DESC')
  end

  def self.most_viewers
    self.select('*, COUNT(DISTINCT customer.customer_id) AS viewer_count')
        .joins(:customers)
        .group('film.film_id')
        .order('COUNT(DISTINCT customer.customer_id) DESC')
  end

  def self.gross_rental_revenue
    self.select('film.film_id, film.rental_rate * COUNT(rental.rental_id) AS revenues')
        .joins(:inventories => :rentals)
        .group('film.film_id')
        .order('(film.rental_rate * COUNT(rental.rental_id)) DESC')
  end
end
