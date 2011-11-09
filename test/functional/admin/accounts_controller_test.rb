require 'test_helper'

class Admin::AccountsControllerTest < ActionController::TestCase
  setup do
    @admin_account = admin_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_account" do
    assert_difference('Admin::Account.count') do
      post :create, :admin_account => @admin_account.attributes
    end

    assert_redirected_to admin_account_path(assigns(:admin_account))
  end

  test "should show admin_account" do
    get :show, :id => @admin_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_account.to_param
    assert_response :success
  end

  test "should update admin_account" do
    put :update, :id => @admin_account.to_param, :admin_account => @admin_account.attributes
    assert_redirected_to admin_account_path(assigns(:admin_account))
  end

  test "should destroy admin_account" do
    assert_difference('Admin::Account.count', -1) do
      delete :destroy, :id => @admin_account.to_param
    end

    assert_redirected_to admin_accounts_path
  end
end
