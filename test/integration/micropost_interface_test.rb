require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :one
  end

  test 'micropost interface' do
    # log in
    log_in_as @user, 'password1'
    get root_path

    assert_select 'input[type="file"]'
    # invalid submission
    assert_no_difference 'Micropost.count' do 
      post microposts_path, params: { micropost: { content: '' } }
    end

    assert_select '#error_explanation'

    # valid submission
    content = 'This micropost really ties the room together.'
    picture = fixture_file_upload('test/fixtures/tree.png', 'image/png')

    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }

    end

    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # visit different user, ensure no delete links
    get user_path users(:two)
    assert_select 'a', text: 'delete', count: 0
  end
end
