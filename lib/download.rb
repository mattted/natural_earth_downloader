class NEDL::Download
  
  attr_reader :name, :size, :version, :type, :url
  @@all = []

  def initialize(name, size, version, type, url)
    @name = name
    @size = size
    @version = version
    @type = type
    @url = url
    @@all << self
  end

  def self.all
    @@all
  end

end