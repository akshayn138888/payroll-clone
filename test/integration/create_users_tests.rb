require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "get new guard form and crete user" do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {email: "guardtest@test.com", password: "password"}
    end
    assert_template root_path
    assert_match "guardtest@test.com", response.body
  end

  test "Invalid email results in failure" do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_no_difference 'User.count' do
      post users_path, user: {email: " ", password: "password"}
    end
    assert_template 'users/registrations/new'
    assert_select 'div.test_purposes'
  end

  test "Invalid password results in failure" do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_no_difference 'User.count' do
      post users_path, user: {email: "newGuardTest@test.com", password: "a"}
    end
    assert_template 'users/registrations/new'
    assert_select 'div.test_purposes'
  end

  test "empty email and password results in failure" do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_no_difference 'User.count' do
      post users_path, user: {email: "", password: ""}
    end
    assert_template 'users/registrations/new'
    assert_select 'div.test_purposes'
  end

end
