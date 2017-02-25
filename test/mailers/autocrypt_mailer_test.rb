require 'test_helper'

class AutocryptMailerTest < ActiveSupport::TestCase

  def test_empty_mail
    mail = AutocryptMailer.mail_with_header
    assert_predicate mail, :present?
  end

  def test_complete_mail_without_autocrypt
    autocrypt.clear
    mail = AutocryptMailer.mail_with_header email_params
    assert_predicate mail.header['Autocrypt'], :blank?
  end

  def test_autocrypt_header
    autocrypt.init
    mail = AutocryptMailer.mail_with_header email_params
    assert_includes mail.header['Autocrypt'].value, 'to=alice'
  end

  def test_encrypted_mail
    autocrypt.init
    autocrypt.process_incoming bobs_email
    mail = AutocryptMailer.mail_with_header email_params
    assert_includes mail.to_s, 'encrypted'
  end

  protected

  def autocrypt
    @autocrypt ||= Autocrypt.new('alice')
  end

  def email_params
    {
      to: 'bob',
      from: 'alice',
      subject: 'subject',
      body: 'body'
    }
  end

  def bobs_email
    Autocrypt.new('bob').init
    AutocryptMailer.mail_with_header to: 'alice',
      from: 'bob',
      subject: 'old email',
      body: 'just so you have the key'
  end


end
