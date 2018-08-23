class EventsController < ApplicationController
  include EventsHelper

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/events"
  API_KEY= ENV['YELP_APIKEY']

  def index

  @response = search(yelp_params[:category], yelp_params[:zip])

  if (@response["total"] == 0)
    flash[:notice] = "No events were found matching that search criteria"
    return
  end

  end

  def create
    event_id = yelp_params[:event_id]
    attending = yelp_params[:attending]

    response = get_event(event_id)

    error = false

    begin
      create_record(response, attending)
    rescue
     error = true
    end

    if error
      head :internal_server_error
    else
      head :ok
    end
  end

  private

    def yelp_params
      params.require(:yelp).permit(:attending, :category, :event_id, :zip)
    end

    def get_event(yelp_event_id)
      url = "#{API_HOST}#{SEARCH_PATH}/#{yelp_event_id}"
      HTTP.auth("Bearer #{API_KEY}").get(url).parse(:json)
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

    def create_record(response, attending)
      is_free = (response['is_free'] == 'true' ? true : false)
      cancelled = (response['is_canceled'] == 'true' ? true : false)
   
      if response['time_end'].nil?
        end_date = nil
        end_time = nil
      else
        end_date = response['time_end'].split(' ')[0]
        end_time = response['time_end'].split(' ')[1]
      end

      current_user.yelp_events.build(
        yelp_event_id: response['id'],
        business_id: response['business_id'],
        name: response['name'],
        description: response['description'],
        display_address: response['location']['display_address'][0],
        image_url: response['image_url'],
        start_date: response['time_start'].split(' ')[0],
        start_time: response['time_start'].split(' ')[1],
        end_date: end_date,
        end_time: end_time,
        cancelled: cancelled,
        cost: response['cost'],
        is_free: is_free,
        tickets_url: response['tickets_url'],
        category: response['category'],
        attending: attending
      ).save!
    end
end
