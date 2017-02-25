class Mailbox

  delegate :size, :each, :map, to: :@files

  def self.find_file(id)
    Dir.glob(datapath('*', '*', id + '.eml')).first
  end

  def initialize(*subdirs)
    path = self.class.datapath(*subdirs)
    FileUtils.mkdir_p path
    @path = path
    @files = Dir.glob path + '*.eml'
  end

  def store(email)
    File.open(storage_path(email), 'w') do |file|
      file.puts email.to_s
    end
    return true
  end

  def clear
    each {|file| File.delete file}
  end

  protected

  attr_reader :path, :files

  def storage_path(email)
    path + email.filename
  end

  def self.datapath(*args)
    AutocryptUi::DATA_PATH.join(*(args.map(&:to_s)))
  end
end
