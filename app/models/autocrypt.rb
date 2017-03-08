class Autocrypt
  include ActiveModel::Model

  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def clear
    FileUtils.rm_rf basedir
  end

  def status
    @status ||= run :status
  end

  def prefer_encrypt
    if initialized?
      /^prefer-encrypt: (yes|no|notset)$/.match(status)[1]
    end
  end

  def prefer_encrypt=(val)
    run 'set-prefer-encrypt', val
  end

  def init
    run :init
  end

  def header
    run "make-header #{name}"
  end

  def initialized?
    ! /Account directory .* not initialized/.match(status)
  end
  alias_method :persisted?, :initialized?

  def process_incoming(mail)
    extract_keys(mail)
  end

  def prepare_outgoing(mail)
    return mail unless initialized?
    mail.dup.tap do |out|
      out.header[header_key] = header_value
      out.body = encrypt(out, keys: keys(out)) || out.body
    end
  end

  # Returns the decrypted body. Leaves mail untouched.
  # Will return an empty string if the mail was not encrypted.
  def decrypt(mail)
    gpg_decrypt mail.path
  end

  def addresses_with_keys_available
    status.scan(/^(.*): key \w* /).map { |m| m.first.capitalize }
  end

  protected

  def encrypt(mail, keys:)
    return unless initialized?
    return if keys.include? nil
    File.open tmpfile(mail), 'w' do |file|
      file.puts mail.body
    end
    gpg_encrypt tmpfile(mail), keys: keys
  end

  def extract_keys(mail)
    return unless initialized?
    run "process-incoming #{mail.path}"
  end

  def keys(mail)
    [mail.to, mail.from].map{|address| key(address)}
  end

  def header_key
    header.split(':', 2).first
  end

  def header_value
    header.split(':', 2).last
  end

  def key(address)
    match = match_key_in_status(address)
    match && match[1]
  end

  def match_key_in_status(address)
    if address == name
      /^own-keyhandle: (\w*)/.match(status)
    else
      /^#{address}: key (\w*) /.match(status)
    end
  end

  def run(*command)
    command = "autocrypt --basedir '#{basedir}' #{command.join(' ')}"
    `#{command}`
  end

  def tmpfile(mail)
    basedir + ".mail.#{mail.id}.tmp"
  end

  def basedir
    AutocryptUi::DATA_PATH.join(name).tap do |path|
      FileUtils.mkdir_p path
    end
  end

  def gpg_encrypt(file, keys:)
    recipients = keys.join ' -r '
    command = "gpg --homedir #{basedir + 'gpghome'} --encrypt -r #{recipients} --yes --batch --trust-model always --armor #{file}"
    `#{command} 2> #{Rails.root + 'log' + 'gpg.log'} && cat #{file}.asc`
  end

  def gpg_decrypt(file)
    command = "gpg --homedir #{basedir + 'gpghome'} --decrypt --armor #{file}"
    out = `#{command} 2> #{Rails.root + 'log' + 'gpg.log'}`
    return out if $?.exitstatus == 0
  end

end
