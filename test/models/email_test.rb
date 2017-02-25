require 'test_helper'

class EmailTest < ActiveSupport::TestCase

  def test_empty_email_instance
    email = Email.new
  end

  def test_attributes
    email = Email.new email_params
    email_params.each {|k,v| assert_equal v, email.send(k)}
  end

  def test_id
    email = Email.new email_params
    assert_nil email.id
    email.save
    assert_predicate email.id, :present?
  end

  def test_persisted
    email = Email.new email_params
    refute_predicate email, :persisted?
    email.save
    assert_predicate email, :persisted?
  end

  def test_email_find
    email = Email.new email_params
    email.save
    assert_equal email, Email.find(email.id)
  end

  def test_save
    email = Email.new email_params
    assert_difference 'Email.to(email.to).size' do
      assert_difference 'Email.from(email.from).size' do
        email.save
      end
    end
    email_params.each {|k,v| assert_equal v, email.send(k)}
  end

  protected

  def email_params
    {
      to: 'bob',
      from: 'alice',
      subject: 'subject',
      body: 'body'
    }
  end
end
