require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :one
  end

  test "user cannot edit with no password" do
    log_in_as @user, 'password1'
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: "", email: "@email.com", password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_template 'users/edit'
    assert_select '#error_explanation ul li', /.*/, count: 4
  end

  test "successful user edit" do
    log_in_as @user, 'password1'
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: "validname", email: "validemail@email.com", password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, 'validname'
    assert_equal @user.email, 'validemail@email.com'
  end

  # testing that user is forwarded to original page after attempting to access a protected page unsuccessfully
  test "friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user, 'password1')
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end

  test "friendly forwarding with successful edit" do
    get edit_user_path(@user)
    log_in_as(@user, 'password1')
    assert_redirected_to edit_user_path(@user)

    name = "foo bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
