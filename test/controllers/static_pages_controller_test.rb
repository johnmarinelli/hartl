require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def  setup 
    @base_title = 'Hartl Tutorial'
  end

  test "should get root" do
    get root_path
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_select "title", "About | #{@base_title}"
    assert_response :success
  end

end
