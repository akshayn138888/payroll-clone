require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # include Devise::Test::ControllerHelpers

  def setup
    @user = users(:one)
  end

  test "Admin should be valid" do
    assert @user.valid?
  end

  test "Email should be present" do
    @user.email = ""
    assert_not @user.valid?
    assert @user.errors[:email]
    assert_equal 'can\'t be blank', @user.errors[:email].join
  end

  test "Email should be unique" do
    @user.save
    @user2 = AdminUser.new(email: "admin@test.com")
    assert_not @user2.valid?
    assert @user.errors[:email]
  end

  test 'should accept valid emails' do
      %w(a.b.c@example.com test_mail@gmail.com any@any.net email@test.br 123@mail.test 1☃3@mail.test).each do |email|
        @user3 = AdminUser.new(email: email)
        assert_not @user3.valid?
        assert @user3.errors[:email]
      end
    end

  test "Password should be present" do
    @user.password = ""
    assert_not @user.valid?
    assert @user.errors[:password]
    # puts "got this far"
  end

  test "password should not be too long" do
    @user2 = AdminUser.new(password: "a"*50)
    assert_not @user2.valid?
    assert @user.errors[:password]
  end

  test 'should require confirmation to be set when creating a new record' do
    @user4 = AdminUser.new(password: 'new_password', password_confirmation: 'blabla')
    assert @user4.invalid?
    assert_equal 'doesn\'t match Password', @user4.errors[:password_confirmation].join
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
