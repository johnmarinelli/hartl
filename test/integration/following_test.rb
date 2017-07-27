require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :one
    @other = users :user_9
    log_in_as @user, 'password1'
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test 'should follow user the standard way' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test 'should follow user using ajax' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test 'should unfollow user the standard way' do
    other = users :two
    relationship = @user.active_relationships.find_by followed_id: other.id
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow user using ajax' do
    other = users :two
    relationship = @user.active_relationships.find_by followed_id: other.id
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test 'should show feed on home page' do
    get root_path
    @user.feed.paginate(page: 1).each do |mp|
      assert_match CGI.escape_html(mp.content), response.body
    end
  end
end