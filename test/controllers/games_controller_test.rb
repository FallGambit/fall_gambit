require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show, :id => 1
    assert_response :success
  end

  test "raises RecordNotFound when not found" do
    get :show, :id => 'OMG'
    assert_response :not_found
  end

end
