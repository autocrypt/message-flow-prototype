class Autocrypt

  attr_reader :name

  def initialize(name)
    @name = name.to_s
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

  protected

  def run(command, &block)
    command = "autocrypt --basedir '#{basedir}' #{command}"
    if block_given?
      yield IO.popen(command, 'r+')
    else
      `#{command}`
    end
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
