require "test_helper"

class Public::PostControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_post_new_url
    assert_response :success
  end

  test "should get show" do
    get public_post_show_url
    assert_response :success
  end

  test "should get create" do
    get public_post_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_post_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_post_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_post_destroy_url
    assert_response :success
  end
end
