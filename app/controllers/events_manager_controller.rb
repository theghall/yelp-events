class EventsManagerController < ApplicationController
  def index
    @events = current_user.yelp_events.attending_yes.limit(3);

    if @events.empty?
      flash[:notice] = 'You have no upcoming events saved'
    end
  end
end
