class RenameTrainstationToSavedSearches < ActiveRecord::Migration[6.0]
  def change
    rename_column :saved_searches, :trainstation, :train_station
  end
end
