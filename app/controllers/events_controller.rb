class EventsController < ApplicationController
  include EventsHelper

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/events"
  API_KEY= ENV['YELP_APIKEY']

  def index

  @response = search(yelp_params[:category], yelp_params[:zip])

  end

  private

  def yelp_params
    params.require(:yelp).permit(:category, :zip)
  end

  def search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    start_date = "#{Time.now.to_i}"
    params = {
      term: term,
      location: location,
    }

    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    response.parse
  end
end
