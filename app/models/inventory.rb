class Inventory < ActiveRecord::Base
  set_table_name(:inventory)
  set_primary_key(:inventory_id)

  belongs_to :film
  belongs_to :store
  has_many :rentals
  has_many :customers, through: :rentals
end