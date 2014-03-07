require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get choose_dates" do
    get :choose_dates
    assert_response :success
  end

  test "should get results" do
    get :results
    assert_response :success
  end

end
