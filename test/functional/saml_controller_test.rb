require 'test_helper'

class SamlControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get consume" do
    get :consume
    assert_response :success
  end

  test "should get complete" do
    get :complete
    assert_response :success
  end

  test "should get fail" do
    get :fail
    assert_response :success
  end

end
