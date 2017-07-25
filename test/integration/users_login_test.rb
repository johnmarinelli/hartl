require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "user does not log in with wrong password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    @user = users :one
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email.downcase, password: 'password1' } }
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "logout" do
    @user = users :one
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email.downcase, password: 'password1' } }
    assert_redirected_to @user
    follow_redirect!

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
  end

  test "login with valid information followed by logout" do
    @user = users :one
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email.downcase, password: 'password1' } }
    assert_redirected_to @user
    follow_redirect!

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    @user = users :one
    log_in_as @user, 'password1', remember_me: '1'
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    @user = users :one
    log_in_as @user, 'password1', remember_me: '1'
    log_in_as @user, 'password1', remember_me: '0'
    assert_empty cookies['remember_token']
  end
end
