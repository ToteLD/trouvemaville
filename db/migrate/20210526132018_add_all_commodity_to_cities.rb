class AddAllCommodityToCities < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :handiwork, :boolean, default: false
    add_column :cities, :grocery, :boolean, default: false
    add_column :cities, :bakery, :boolean, default: false
    add_column :cities, :butchery, :boolean, default: false
    add_column :cities, :fish_market, :boolean, default: false
    add_column :cities, :bookstore, :boolean, default: false
    add_column :cities, :clothe, :boolean, default: false
    add_column :cities, :shoestore, :boolean, default: false
    add_column :cities, :it, :boolean, default: false
    add_column :cities, :furniture, :boolean, default: false
    add_column :cities, :sport, :boolean, default: false
    add_column :cities, :hardware, :boolean, default: false
    add_column :cities, :cosmetic, :boolean, default: false
    add_column :cities, :jewellery, :boolean, default: false
    add_column :cities, :plant, :boolean, default: false
    add_column :cities, :optic, :boolean, default: false
    add_column :cities, :medical_store, :boolean, default: false
    add_column :cities, :gas_station, :boolean, default: false
  end
end
