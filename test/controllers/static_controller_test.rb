require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get static_show_url
    assert_response :success
  end

end
