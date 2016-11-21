require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  # include Devise::Test::ControllerHelpers

  def setup
    @AdminUserTest = admin_users(:one)
  end

  test "Admin should be valid" do
    assert @AdminUserTest.valid?
  end

  test "Email should be present" do
    @AdminUserTest.email = ""
    assert_not @AdminUserTest.valid?
    assert @AdminUserTest.errors[:email]
    assert_equal 'can\'t be blank', @AdminUserTest.errors[:email].join
  end

  test "Email should be unique" do
    @AdminUserTest.save
    @AdminUserTest2 = AdminUser.new(email: "admin@test.com")
    assert_not @AdminUserTest2.valid?
    assert @AdminUserTest.errors[:email]
  end

  test 'should accept valid emails' do
      %w(a.b.c@example.com test_mail@gmail.com any@any.net email@test.br 123@mail.test 1☃3@mail.test).each do |email|
        @AdminUserTest3 = AdminUser.new(email: email)
        assert_not @AdminUserTest3.valid?
        assert @AdminUserTest3.errors[:email]
      end
    end

  test "Password should be present" do
    @AdminUserTest.password = ""
    assert_not @AdminUserTest.valid?
    assert @AdminUserTest.errors[:password]
    # puts "got this far"
  end

  test "password should not be too long" do
    @AdminUserTest2 = AdminUser.new(password: "a"*50)
    assert_not @AdminUserTest2.valid?
    assert @AdminUserTest.errors[:password]
  end

  test 'should require confirmation to be set when creating a new record' do
    @AdminUserTest4 = AdminUser.new(password: 'new_password', password_confirmation: 'blabla')
    assert @AdminUserTest4.invalid?
    assert_equal 'doesn\'t match Password', @AdminUserTest4.errors[:password_confirmation].join
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
