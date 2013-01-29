class Store < ActiveRecord::Base
  set_table_name(:store)
  set_primary_key(:store_id)

  has_many :inventories
  has_many :films, through: :inventories
  belongs_to :address
  has_one :country, through: :address
end