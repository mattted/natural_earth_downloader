class NEDL::Download
  
  attr_reader :name, :size, :version, :type, :theme, :url
  @@all = []

  def initialize(name, size, version, type, theme, url)
    @name = name
    @size = size
    @version = version
    @type = type
    @theme = theme
    @url = url
    @@all << self
  end

  def self.all
    @@all
  end

end