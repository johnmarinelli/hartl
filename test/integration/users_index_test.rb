require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :one
  end

  test "index including pagination" do
    log_in_as @user, 'password1'
    get users_path
    assert_template 'users/index'
    assert_select '.users li', count: 30

    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "unauthenticated user can't see user index" do
    get users_path
    assert_redirected_to login_url
  end
end
