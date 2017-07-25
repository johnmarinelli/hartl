require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :one
    @other_user = users :two
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

  test "non admin user can't see delete link" do
    log_in_as @other_user, 'password2'
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
