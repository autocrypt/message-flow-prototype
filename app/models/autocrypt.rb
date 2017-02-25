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
    File.open '/tmp/tmp-mail', 'w' do |file|
      file.puts mail
    end
    run 'process-incoming /tmp/tmp-mail'
  end

  protected

  def run(command, &block)
    command = "autocrypt --basedir '/tmp/autocrypt/#{name}' #{command}"
    if block_given?
      yield IO.popen(command, 'r+')
    else
      `#{command}`
    end
  end
end
