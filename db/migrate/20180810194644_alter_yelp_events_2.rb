class AlterYelpEvents2 < ActiveRecord::Migration[5.2]
  def change
    remove_column :yelp_events, :saved
    rename_column :yelp_events, :date, :start_date
    rename_column :yelp_events, :time, :start_time
    add_column :yelp_events, :end_date, :string
    add_column :yelp_events, :end_time, :string
    add_index :yelp_events, [:yelp_event_id, :start_date], unique: true
  end
end
