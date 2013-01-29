class FilmCategory < ActiveRecord::Base
  set_table_name(:film_category)

  belongs_to :film
  belongs_to :category
end