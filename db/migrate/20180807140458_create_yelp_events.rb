class CreateYelpEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :yelp_events do |t|
      t.string :yelp_event_id
      t.string :business_id
      t.string :name
      t.string :description
      t.string :display_address
      t.string :image_url
      t.string :date
      t.string :time
      t.boolean :cancelled
      t.string :cost
      t.boolean :is_free
      t.boolean :tickets_required
      t.string :tickets_url
      t.string :category
      t.boolean :save_offline

      t.timestamps
    end
    add_index :yelp_events, :business_id
    add_index :yelp_events, :category
  end
end
