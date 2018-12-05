ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def yelp_event
    {
      "attending_count": 4,
      "category": "food-and-drink",
      "cost": "5.0",
      "cost_max": '',
      "description": "Saucy is throwing up a pop-up restaurant party over at Anfilo Coffee! Give the menu a little peruse and then register to reserve your spot! Prices are shown...",
      "event_site_url": "https://www.yelp.com/events/oakland-saucy-oakland-restaurant-pop-up",
      "id": "oakland-saucy-oakland-restaurant-pop-up",
      "image_url": "https://s3-media2.fl.yelpcdn.com/ephoto/TZ0gQ1nSBVe_X4PYg44s0w/o.jpg",
      "interested_count": 9,
      "is_canceled": false,
      "is_free": false,
      "is_official": false,
      "latitude": 37.8114102,
      "longitude": -122.2665892,
      "name": "Saucy Oakland | Restaurant Pop-Up",
      "tickets_url": "https://www.eventbrite.com/e/saucy-oakland-restaurant-pop-up-tickets-36287157866?aff=es2#tickets",
      "time_end": "2017-08-19T04:00",
      "time_start": "2017-08-19T01:00",
      "location": {
        "address1": "35 Grand Ave",
        "address2": "",
        "address3": "",
        "city": "Oakland",
        "zip_code": "94612",
        "country": "US",
        "state": "CA",
        "display_address": [
          "35 Grand Ave",
          "Oakland, CA 94612"
        ],
        "cross_streets": "Broadway & Webster St"
      },
      "business_id": "anfilo-oakland-2"
    }
  end
end
