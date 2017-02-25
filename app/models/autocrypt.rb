class Autocrypt

  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def clear
    FileUtils.rm_rf basedir
  end

  def status
    run :status
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
    File.open tmpfile, 'w' do |file|
      file.puts mail.to_s
    end
    run "process-incoming #{tmpfile}"
  end

  def try_to_encrypt(attribs = {})
    keys = [attribs[:to], attribs[:from]].map{|address| key(address)}
    if keys.include? nil
      attribs[:body]
    else
      encrypt attribs[:body], keys: keys
    end
  end

  protected

  def encrypt(plaintext, keys:)
    plaintext + ' encrypted to ' + keys.to_sentence
  end

  def key(address)
    return "own key of #{address}" if address == name
    /^#{address}: key \w*/.match status
  end

  def run(command)
    command = "autocrypt --basedir '#{basedir}' #{command}"
    `#{command}`
  end

  def tmpfile
    basedir + '.mail.tmp'
  end

  def basedir
    AutocryptUi::DATA_PATH.join(name).tap do |path|
      FileUtils.mkdir_p path
    end
  end

end
