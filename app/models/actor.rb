class Actor < ActiveRecord::Base
  set_table_name(:actor)
  set_primary_key(:actor_id)

  has_many :roles, class_name: 'Role'
  has_many :films, through: :roles
  has_many :categories, through: :films

  def self.most_prolific
    self.select('*, COUNT(*) AS film_count')
        .joins(:roles)
        .group('actor.actor_id')
        .order('COUNT(*) DESC')
  end

  def self.longest_careers
    self.select('*, (MAX(film.release_year) - MIN(film.release_year)) AS career_length')
        .joins(:films)
        .group('actor.actor_id')
        .order('(MAX(film.release_year) - MIN(film.release_year)) DESC')
  end

  def self.highest_grossing
    # self.select('actor.*, (SUM(film.rental_rate * COUNT(rental.rental_id) / COUNT(film.film_id))')
    #     .joins('')
    #     .joins(:films => [{ :inventories => :rentals }])
    #     .group('actor.actor_id')

    self.find_by_sql( %Q{
      SELECT actor.*, AVG(gross)
      FROM actor x
      JOIN film_actor ON actor.actor_id = film_actor.actor_id
      JOIN film ON film_actor.film_id = film.film_id
      JOIN inventory ON inventory.film_id = film.film_id
      JOIN rental ON rental.inventory_id = inventory.inventory_id
      JOIN (
        SELECT y.actor_id, film.film_id, (COUNT(rental.rental_id) * film.rental_rate)
        FROM actor y
        WHERE x.actor_id = y.actor_id)
      ON asdf.actor_id = x.actor_id
      AS gross
      GROUP BY actor.actor_id
      ORDER BY avg_gross DESC
      AS outer})
  end
end