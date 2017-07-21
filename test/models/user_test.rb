require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: 'user3', email: 'email@hotmail.com', password: 'barfoo', password_confirmation: 'barfoo')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "             "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "             "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 500
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 500 + '@hotmail.com'
    assert_not @user.valid?
  end

  test "email is valid" do
    @user.email = 'abcdefnot@email,com'
    assert_not @user.valid?
  end

  test "emails should be unique" do
    dupe = @user.dup
    @user.save
    assert_not dupe.valid?
  end

  test "emails should be unique and case insensitive" do
    dupe = @user.dup
    dupe.email = @user.email.upcase
    @user.save
    assert_not dupe.valid?
  end

  test "emails are saved as lowercase" do
    new_email = "foOOoO@eXampLe.CoM"
    @user.email = new_email
    @user.save
    assert_equal new_email.downcase, @user.email
  end

  test "passwords should be non blank" do
    @user.password = @user.password_confirmation = ' '
    assert_not @user.valid?
  end

  test "passwords have minimum length of 6" do
    @user.password = @user.password_confirmation = 's'
    assert_not @user.valid?
  end
end
