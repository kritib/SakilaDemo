class Address < ActiveRecord::Base
  set_table_name(:address)
  set_primary_key(:address_id)

  belongs_to :city
  has_one :store
  has_one :country, through: :city
end