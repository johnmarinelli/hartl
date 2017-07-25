require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid data does not create user" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "", email: "notagoodemail", password: "foo", password_confirmation: "bar" }}
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
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
