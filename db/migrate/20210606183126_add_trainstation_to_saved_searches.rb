class AddTrainstationToSavedSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :saved_searches, :trainstation, :boolean, default: false
  end
end
