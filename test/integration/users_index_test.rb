require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should get the index page and links when logged in" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select "li"
    assert_select "ul.users"
    assert_select "a"
    assert_select "img"
  end

  test "should redirect to login page when not logged in" do
    get users_path
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to users_path
  end

  # test "the truth" do
  #   assert true
  # end
end
