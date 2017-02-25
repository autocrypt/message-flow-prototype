require 'test_helper'

class MailboxTest < ActiveSupport::TestCase

  def test_size
    assert_equal 0, box.size
  end

  def test_store
    assert_difference 'box.size' do
      box.store email_dummy
    end
  end

  def test_each
    box.store email_dummy
    box.each do |mail|
      assert_match '/bob/test/1234.eml', mail
    end
  end

  protected

  def box
    Mailbox.new('bob', 'test').tap do |box|
      box.clear
    end
  end

  def email_dummy
    Object.new.tap do |mail|
      def mail.filename; '1234.eml'; end
      def mail.to_s; 'dummy mail'; end
    end
  end
end
