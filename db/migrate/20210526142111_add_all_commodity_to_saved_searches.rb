class AddAllCommodityToSavedSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :saved_searches, :handiwork, :boolean, default: false
    add_column :saved_searches, :grocery, :boolean, default: false
    add_column :saved_searches, :bakery, :boolean, default: false
    add_column :saved_searches, :butchery, :boolean, default: false
    add_column :saved_searches, :fish_market, :boolean, default: false
    add_column :saved_searches, :bookstore, :boolean, default: false
    add_column :saved_searches, :clothe, :boolean, default: false
    add_column :saved_searches, :shoestore, :boolean, default: false
    add_column :saved_searches, :it, :boolean, default: false
    add_column :saved_searches, :furniture, :boolean, default: false
    add_column :saved_searches, :sport, :boolean, default: false
    add_column :saved_searches, :hardware, :boolean, default: false
    add_column :saved_searches, :cosmetic, :boolean, default: false
    add_column :saved_searches, :jewellery, :boolean, default: false
    add_column :saved_searches, :plant, :boolean, default: false
    add_column :saved_searches, :optic, :boolean, default: false
    add_column :saved_searches, :medical_store, :boolean, default: false
    add_column :saved_searches, :gas_station, :boolean, default: false
  end
end
