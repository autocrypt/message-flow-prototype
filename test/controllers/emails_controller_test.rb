require 'test_helper'

class EmailsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get user_emails_url 'bob'
    assert_response :success
  end

  test "should get new" do
    get new_user_email_url 'bob'
    assert_response :success
  end

  test "should create email" do
    @email = emails :one
    assert_difference('Email.count') do
      post emails_url, params: { email: { body: @email.body, from: @email.from, subject: @email.subject, to: @email.to } }
    end
    assert_redirected_to email_url(Email.last)
  end

  test "should show email" do
    @email = emails :one
    get email_url(@email)
    assert_response :success
  end

end
