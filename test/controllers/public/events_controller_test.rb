require "test_helper"

class Public::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_events_show_url
    assert_response :success
  end
end
