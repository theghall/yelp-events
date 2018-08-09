require 'test_helper'

class EventFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
  end

  test "it should display login page" do
    get root_url
    follow_redirect!
    assert_template "devise/sessions/new"
  end

  test "it should display event search page" do
    sign_in @user
    get root_url
    assert_template "static/home"
  end
end
