module EventsHelper
  def pad_cost(cost)
    return "Free" if cost.nil?

    dollars_cents = cost.to_s.split('.')

    if (dollars_cents[1].length < 2)
      dollars_cents[1] = dollars_cents[1] + "0"
    end

    dollars_cents.join('.')
  end

  def get_address(display_address)
    display_address.split(',')[0]
  end

  def get_city_state_zip(display_address)
    address_split = display_address.split(',')

    if address_split.length <= 1
      return ''
    else
      return address_split[1] + ',' + address_split[2]
    end

  end

  def format_date_time(starts, ends)
    no_end = ends.nil?

    s_date_time = starts.split(' ')
    s_date = s_date_time[0].split('-')
    s_time = s_date_time[1].split(':');

    start_date_time = DateTime.new(s_date[0].to_i, s_date[1].to_i, s_date[2].to_i, s_time[0].to_i, s_time[1].to_i)

    if !no_end
      e_date_time = ends.split(' ')
      e_date = e_date_time[0].split('-')
      e_time = e_date_time[1].split(':');

      end_date_time = DateTime.new(e_date[0].to_i, e_date[1].to_i, e_date[2].to_i, e_time[0].to_i, e_time[1].to_i)
    end


    if no_end
      return start_date_time.strftime("%b %d, %Y %l%p")
    else
      return start_date_time.strftime("%b %d, %Y %l%p") + " to " + end_date_time.strftime("%l%p")
    end
  end

  def getAttending(event_id, start_date)
    relation = YelpEvent.select(:attending).where(yelp_event_id: event_id, start_date: start_date)

    relation.empty? ? nil : relation.first.attending
  end
end
