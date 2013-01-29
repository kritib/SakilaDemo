class Country < ActiveRecord::Base
  set_table_name(:country)
  set_primary_key(:country_id)

  has_many :cities
  has_many :addresses, through: :cities
  has_many :stores, through: :addresses

  def self.most_popular_actors
    # self.select('country.*, actor.*, COUNT(rental.rental_id) AS rent_count')
    #     .joins(:stores)
    #     .joins('JOIN inventory ON inventory.store_id = store.store_id')
    #     .joins('JOIN rental ON rental.inventory_id = inventory.inventory_id')
    #     .joins('JOIN film ON inventory.film_id = film.film_id')
    #     .joins('JOIN film_actor ON film_actor.film_id = film.film_id')
    #     .joins('JOIN actor ON film_actor.actor_id = actor.actor_id')
    #     .group('country.country_id, actor.actor_id')
    #     .order('COUNT(rental.rental_id) DESC')

    self.select('country.*, actor.*, COUNT(rental.rental_id) AS rent_count')
        .joins(:stores => [{ :inventories => [:rentals, { :film => [{ :roles => :actor }] }] }])
        .group('country.country_id, actor.actor_id')
        .order('COUNT(rental.rental_id) DESC')
  end

  def most_popular_actors

    Actor.select('*, COUNT(rental.rental_id) AS rent_count')
         .joins(:roles => [{ :film => [{ :inventories => [:rentals, { :store => [:country] }] }] }])
         .group('actor.actor_id')
         .where('country.country_id = ?', self.id)
         .order('COUNT(rental.rental_id) DESC')


    # Actor.select('*, COUNT(rental.rental_id) AS rent_count')
    #      .joins('JOIN film_actor ON actor.actor_id = film_actor.actor_id')
    #      .joins('JOIN film ON film.film_id = film_actor.film_id')
    #      .joins('JOIN inventory ON film.film_id = inventory.film_id')
    #      .joins('JOIN rental ON inventory.inventory_id = rental.inventory_id')
    #      .joins('JOIN store ON inventory.store_id = store.store_id')
    #      .joins('JOIN address ON address.address_id = store.address_id')
    #      .joins('JOIN city ON city.city_id = address.city_id')
    #      .joins('JOIN country ON city.country_id = country.country_id')
    #      .group('actor.actor_id')
    #      .where('country.country_id = ?', self.id)
    #      .order('COUNT(rental.rental_id) DESC')
  end
end