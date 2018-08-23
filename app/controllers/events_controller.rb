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
    
      current_user.yelp_events.build(
        yelp_event_id: response['id'],
        business_id: response['business_id'],
        name: response['name'],
        description: response['description'],
        display_address: response['location']['display_address'][0],
        image_url: response['image_url'],
        start_date: response['time_start'].split(' ')[0],
        start_time: response['time_start'].split(' ')[1],
        end_date: response['time_end'].split(' ')[0],
        end_time: response['time_end'].split(' ')[1],
        cancelled: cancelled,
        cost: response['cost'],
        is_free: is_free,
        tickets_url: response['tickets_url'],
        category: response['category'],
        attending: attending
      ).save!
    end

    def write_offline_event(file, event)
      file.write('<div class="info">')
      file.write("<p>#{event.name}</p>")
      file.write("<p>#{event.description}</p>")
      file.write("<p>#{get_address(event.display_address)}</p>")
      file.write("<p>#{get_city_state_zip(event.display_address)}</p>")

      start_date = event.start_date + " " + event.start_time
      end_date = event.end_date + " " + event.end_time

      file.write("<p>Date & Time: #{format_date_time(start_date, end_date)}</p>")
      file.write("<p>Cost: #{pad_cost(event.cost)}</p>")
    end

    def create_offline_html
      path = Rails.public_path.join('offline.html').to_s

      File.open(path, "w+") do |f|
        f.write("<!DOCTYPE html>")
        f.write('<html lang="en">')
        f.write("<head>")
        f.write('<meta charset="utf-8">')
        f.write('<meta name="viewport" content="width=device-width, initial-scale=1">')
        f.write("<title>Yelp Event Assistant | Offline</title>")
        f.write("</head>")
        f.write("<body>")
        YelpEvent.attending_yes.limit(3).each do |event|
          write_offline_event(f, event)
        end
        f.write("</body>")
        f.write("</html>")
      end
    end

end
