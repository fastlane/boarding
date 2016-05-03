require 'test_helper'

class ManageControllerTest < ActionController::TestCase
  test "should get external" do
    get :external
    assert_response :success
  end

end
