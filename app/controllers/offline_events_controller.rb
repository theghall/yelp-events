class OfflineEventsController < ApplicationController

  def index
    @events = current_user.yelp_events.attending_yes.limit(3)

    if (@events.empty?)
      render layout: "offline", :locals => {:message => 'If you had upcoming events you would see them here'}
    else
      render layout: "offline", :locals => {:message => 'Here are some upcoming events you are attending'}
    end
  end
end
