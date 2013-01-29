class Customer < ActiveRecord::Base
  set_table_name(:customer)
  set_primary_key(:customer_id)

  has_many :rentals
  has_many :films, through: :rentals

  def self.watched_most_films
    self.select('*, COUNT(DISTINCT film.film_id) AS film_count')
        .joins(:films)
        .group('customer.customer_id')
        .order('COUNT(DISTINCT film.film_id) DESC')
  end

  def film_count_per_category
    Category.select('*, COUNT(DISTINCT film.film_id) AS film_count')
            .joins('JOIN film_category ON category.category_id = film_category.category_id')
            .joins('JOIN film ON film.film_id = film_category.film_id')
            .joins('JOIN inventory ON inventory.film_id = film.film_id')
            .joins('JOIN rental ON rental.inventory_id = inventory.inventory_id')
            .where('rental.customer_id = ?', self.id)
            .group('category.category_id')
            .order('COUNT(DISTINCT film.film_id) DESC')
  end
end