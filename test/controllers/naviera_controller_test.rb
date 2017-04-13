require 'test_helper'

class NavieraControllerTest < ActionController::TestCase
  test "should get apl" do
    get :apl
    assert_response :success
  end

end
