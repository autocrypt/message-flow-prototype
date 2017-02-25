class Email
  include ActiveModel::Model

  delegate :subject, :to_s, :date, to: :mail
  attr_reader :id

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
      @mail = Mail.read attribs_or_file
      @id = mail.message_id.split('@').first
    else
      @mail = AutocryptMailer.mail_with_header attribs_or_file
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
