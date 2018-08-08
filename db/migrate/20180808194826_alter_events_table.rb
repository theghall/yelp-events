class AlterEventsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :yelp_events, :save_offline
    add_column :yelp_events, :saved, :boolean
    add_column :yelp_events, :attending, :boolean
    add_reference :yelp_events, :user
    add_foreign_key :yelp_events, :users
  end
end
