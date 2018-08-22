class EventsManagerController < ApplicationController
  def index
    @events = current_user.yelp_events.attending_yes.limit(3);
  end
end
