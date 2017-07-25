require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup 
    ActionMailer::Base.deliveries.clear
  end
  test "invalid data does not create user" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "", 
                                          email: "notagoodemail", 
                                          password: "foo", 
                                          password_confirmation: "bar" }}
      assert_template 'users/new'
      assert_select '#error_explanation'
      assert_select '.field_with_errors'
      assert_not flash.empty?
    end
  end

  test "valid data does create user" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "valid", email: "agoodemail@yahoo.com", password: "password", password_confirmation: "password" }}
    end
    follow_redirect!
    #assert_template 'users/show'
    #assert_not flash.empty?
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "namename", 
                                          email: "email@test.com", 
                                          password: "foobar",  
                                          password_confirmation: "foobar" } }
    end

    assert_equal  1, ActionMailer::Base.deliveries.size

    # recall: `assigns` lets us grab the value of this instance variable from the controller
    user = assigns :user
    assert_not user.activated?

    # test not able to log in before activating
    log_in_as user, 'foobar'
    assert_not is_logged_in?

    # test invalid activation token
    get edit_account_activation_path("invalid_token", email: user.email)
    assert_not is_logged_in?

    # test invalid email
    get edit_account_activation_path(user.activation_token, email: 'nope')
    assert_not is_logged_in?

    # valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!

    assert_template 'users/show'
    assert is_logged_in?
  end
end
