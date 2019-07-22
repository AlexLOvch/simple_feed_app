# frozen_string_literal: true

class AddAgencyApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :agency_apartments do |t|
      t.references :agency, foreign_key: true
      t.references :apartment, index: true, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, null: false
    end

    add_index :agency_apartments, %i[agency_id apartment_id], unique: true
  end
end
