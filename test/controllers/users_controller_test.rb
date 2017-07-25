require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @other_user = users :two
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { name: "valid", email: "valid@email.com", password: "passwordlmao", password_confirmation: "passwordlmao" } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should get login" do
    get login_path
    assert_response :success
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "unauthenticated user should be redirected to login page when trying to delete a user" do
    assert_no_difference('User.count') do
      delete user_path(users(:user_10))
    end

    assert_redirected_to login_url
  end

  test "authenticated, non-admin user should be redirected to homepage when trying to delete a user" do
    log_in_as @other_user, 'password2'
    assert_no_difference('User.count') do
      delete user_path(@user)
    end

    assert_redirected_to root_url
  end

  # testing that edit and update are protected from public
  test "should redirect edit when not logged in." do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in." do
    patch user_path(@user), params: { user: { name: @user.name, 
                                             email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # testing that edit and update are protected from other users
  test "should redirect edit when wrong user" do
    log_in_as @other_user, 'password2'
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when wrong user" do
    log_in_as @other_user, 'password2'
    patch user_path(@user), params: { user: { name: @user.name, 
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow admin attribute to be edited from web" do
    log_in_as @other_user, 'password2'
    assert_not @other_user.admin?

    patch user_path(@other_user), params: { user: { password: 'password2', password_confirmation: 'password2', admin: true } }
    assert_not flash.empty?
    assert_not @other_user.admin?
  end

end
