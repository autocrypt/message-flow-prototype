class Autocrypt

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def status
    run :status
  end

  def init
    run :init
  end

  def initialized?
    ! /Account directory .* not initialized/.match(status)
  end

  def run(command)
    `autocrypt --basedir '/tmp/autocrypt/#{name}' #{command}`
  end
end
