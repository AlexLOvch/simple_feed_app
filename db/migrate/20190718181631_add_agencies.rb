# frozen_string_literal: true

class AddAgencies < ActiveRecord::Migration[5.2]
  def change
    create_table :agencies do |t|
      t.string :agency_name, null: false
      t.integer :priority, null: false
    end

    add_index :agencies, :agency_name, unique: true
  end
end
