require 'mail'

#
# An ActiveModel wrapper around Mail to make using it in views easier.
#

class Email
  include ActiveModel::Model

  delegate :subject, :to_s, :date, :header, :body=, to: :mail
  attr_reader :id, :source, :path
  attr_accessor :encrypt

  def self.to(recipient)
    Mailbox.new(recipient, 'inbox').map{|path| new path}
  end

  def self.from(sender)
    Mailbox.new(sender, 'sent').map{|path| new path}
  end

  def self.find(id)
    new Mailbox.find_file(id)
  end

  def initialize(attribs_or_file = {})
    if attribs_or_file.is_a? String
      @path = attribs_or_file
      @mail = Mail.read attribs_or_file
      @source = @mail.to_s
      @id = mail.message_id.split('@').first
    else
      @mail = mail_from_params(attribs_or_file)
    end
  end

  def mail_from_params(params)
    @mail = Mail.new do |mail|
      mail.from params[:from]
      mail.to params[:to]
      mail.subject params[:subject]
      mail.body params[:body]
    end
  end

  def ==(other)
    other.id == id
  end

  def to
    mail.to && mail.to.first
  end

  def from
    mail.from && mail.from.first
  end

  def body
    mail.body.to_s
  end

  alias_method :to_param, :id

  def filename
    id + '.eml'
  end

  def save
    mail.to_s # calculates message_id in the mail
    @id = mail.message_id.split('@').first
    inbox.store(self) && sent.store(self)
  end

  def persisted?
    !!id
  end

  protected

  attr_reader :mail

  def inbox
    Mailbox.new(to, 'inbox')
  end

  def sent
    Mailbox.new(from, 'sent')
  end

end
