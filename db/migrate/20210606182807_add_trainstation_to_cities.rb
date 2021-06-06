class AddTrainstationToCities < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :train_station, :boolean, default: false
  end
end
