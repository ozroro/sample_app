require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @activated_user = users(:archer)
    @non_activated_user = users(:tim)
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

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index not including non-activated user" do
    log_in_as(@activated_user)
    get users_path
    # assert_select 'a[href=?]', user_path(@activated_user), text: @activated_user.name
    assert_select 'a[href=?]', user_path(@non_activated_user), text: @non_activated_user.name, count: 0
  end

  test "should redirect to root_url when get non-activated user page path " do
    log_in_as(@activated_user)
    # get user_path(@user)
    # assert_template 'users/show'
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end
  # test "the truth" do
  #   assert true
  # end
end
