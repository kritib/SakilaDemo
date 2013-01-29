class Category < ActiveRecord::Base
  set_table_name(:category)

  has_many :film_categories
  has_many :films, through: :film_categories
  has_many :actors, through: :films

  def self.most_popular
    self.select('*, COUNT(*) AS film_count')
        .joins(:film_categories)
        .group('category.category_id')
        .order('COUNT(*) DESC')
  end

  def self.most_rented
    self.select('*, COUNT(rental.rental_id) AS rental_count')
        .joins('JOIN film_category ON category.category_id = film_category.category_id')
        .joins('JOIN film ON film.film_id = film_category.film_id')
        .joins('JOIN inventory ON inventory.film_id = film.film_id')
        .joins('JOIN rental ON rental.inventory_id = inventory.inventory_id')
        .group('category.category_id')
        .order('COUNT(rental.rental_id) DESC')
  end
end