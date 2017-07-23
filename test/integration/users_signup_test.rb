require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid data does not create user" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", email: "notagoodemail", password: "foo", password_confirmation: "bar" }}
    end
  end

  test "valid data does create user" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "valid", email: "agoodemail@yahoo.com", password: "password", password_confirmation: "password" }}
    end
    follow_redirect!
    assert_template 'users/show'
  end
end
