require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Hartl Tutorial"
    assert_equal full_title("a"), "a | Hartl Tutorial"
  end

end
