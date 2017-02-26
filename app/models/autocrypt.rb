class Autocrypt

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

  def init
    run :init
  end

  def header
    run "make-header #{name}"
  end

  def initialized?
    ! /Account directory .* not initialized/.match(status)
  end

  def process_incoming(mail)
    return unless initialized?
    File.open mail.filename, 'w' do |file|
      file.puts mail.to_s
    end
    run "process-incoming #{mail.filename}"
  end

  def prepare_outgoing(mail)
    out = mail.dup
    out.header[header_key] = header_value
    return try_to_encrypt(out)
  end


  def try_to_encrypt(mail)
    keys = [mail.to, mail.from].map{|address| key(address)}
    encrypt mail, keys: keys unless keys.include? nil
    mail
  end

  protected

  def header_key
    header.split(':', 2).first
  end

  def header_value
    header.split(':', 2).last
  end

  def encrypt(mail, keys:)
    return unless initialized?
    File.open tmpfile(mail), 'w' do |file|
      file.puts mail.body
    end
    mail.body = gpg tmpfile(mail), keys: keys
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

  def run(command)
    command = "autocrypt --basedir '#{basedir}' #{command}"
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

  def gpg(file, keys:)
    recipients = keys.join ' -r '
    command = "gpg2 --homedir #{basedir + 'gpghome'} --encrypt -r #{recipients} --yes --batch --trust-model always --armor #{file}"
    `#{command} && cat #{file}.asc`
  end
end
