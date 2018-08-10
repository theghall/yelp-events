class AlterYelpEventsAttending < ActiveRecord::Migration[5.2]
  def change
    change_column :yelp_events, :attending, :string
  end
end
