require 'test_helper'
require 'minitest/mock'
require 'minitest/autorun'

class EventFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
  end

  test "it should display login page when getting root url if not signed in" do
    get root_url
    follow_redirect!
    assert_template "devise/sessions/new"
  end

  test "it should display login page when getting offline_events url if not signed in" do
    get offline_events_url
    follow_redirect!
    assert_template "devise/sessions/new"
  end

  test "it should display event search page" do
    sign_in @user
    get root_url
    assert_template "static/home"
  end

  test "it should add an event record" do
    authorization = 'Bearer ' + "#{ENV['YELP_APIKEY']}"
    attending = "yes"
    event_id  = yelp_event[:id]

    sign_in @user
    stub_request(:get, "https://api.yelp.com/v3/events/#{event_id}").
      with(
      headers: {
      'Authorization'=>"#{authorization}",
      'Connection'=>'close',
      'Host'=>'api.yelp.com',
      'User-Agent'=>'http.rb/3.3.0',
      }).
      to_return(status: 200, body: JSON.generate(yelp_event), headers: {'ContentType' => 'application/json'})

    assert_difference 'YelpEvent.count', 1 do
     post events_path, params: {yelp: {event_id: "#{event_id}", attending: "#{attending}"} }
    end

    event_rec = YelpEvent.where(yelp_event_id: event_id)
    refute_empty event_rec

    event_rec = event_rec.first
    event_data = yelp_event

    assert_equal event_id, event_rec.yelp_event_id
    assert_equal event_data[:business_id], event_rec.business_id
    assert_equal event_data[:name], event_rec.name
    assert_equal event_data[:location][:display_address][0], event_rec.display_address
    assert_equal event_data[:image_url], event_rec.image_url
    assert_equal event_data[:time_start].split(' ')[0], event_rec.start_date
    assert_equal event_data[:time_start].split(' ')[1], event_rec.start_time
    assert_equal event_data[:time_end].split(' ')[0], event_rec.end_date
    assert_equal event_data[:time_end].split(' ')[1], event_rec.end_time
    assert_equal event_data[:is_canceled], event_rec.cancelled
    assert_equal event_data[:cost], event_rec.cost
    assert_equal event_data[:is_free], event_rec.is_free
    assert_equal event_data[:tickets_url], event_rec.tickets_url
    assert_equal event_data[:category], event_rec.category
    assert_equal attending, event_rec.attending
  end

  test "it should not allow a duplicate event (yelp_event_id + start_date)" do
    authorization = 'Bearer ' + "#{ENV['YELP_APIKEY']}"
    attending = "yes"
    event_id  = yelp_event[:id]

    sign_in @user
    stub_request(:get, "https://api.yelp.com/v3/events/#{event_id}").
      with(
      headers: {
      'Authorization'=>"#{authorization}",
      'Connection'=>'close',
      'Host'=>'api.yelp.com',
      'User-Agent'=>'http.rb/3.3.0',
      }).
      to_return(status: 200, body: JSON.generate(yelp_event), headers: {'ContentType' => 'application/json'})

    assert_difference 'YelpEvent.count', 1 do
     post events_path, params: {yelp: {event_id: "#{event_id}", attending: "#{attending}"} }
    end

    post events_path, params: {yelp: {event_id: "#{event_id}", attending: "#{attending}"} }
    assert_response :error

  end

  test "it should display OfflineEvents/index template" do
    sign_in @user
    get offline_events_path
    assert_template "offline_events/index"
  end
end
