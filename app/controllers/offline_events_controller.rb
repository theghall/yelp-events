class OfflineEventsController < ApplicationController

  def index
    @events = current_user.yelp_events.attending_yes.limit(3)

    render layout: "offline"
  end
end
