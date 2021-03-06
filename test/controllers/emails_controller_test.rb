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
    assert_difference('Email.to("bob").size') do
      post user_emails_url(email_params[:from]),
        params: { email: email_params }
    end
    last_email = Email.to('bob').max_by {|m| m.id}
    assert_redirected_to user_email_url(email_params[:from], last_email)
  end

  test "should show email" do
    get user_email_url(email.to, email)
    assert_response :success
  end

  protected

  def email
    Email.new(email_params).tap do |email|
      email.save
    end
  end

  def email_params
    {
      to: 'bob',
      from: 'alice',
      subject: 'subject',
      body: 'body'
    }
  end
end
