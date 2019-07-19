class AddApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :address, null: false
      t.string :apartment, null: false
      t.string :city, null: false
    end

    add_index :apartments, [:address, :apartment, :city], unique: true
  end
end
