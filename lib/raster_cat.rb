class NEDL::DataRasterCat

  attr_accessor :name, :desc, :theme, :url_add
  @@all = []

  def initialize(name, desc, url_add, theme)
    @name = name
    @desc = desc
    @url_add = url_add
    @theme = theme
    @@all << self
  end

  def self.all
    @@all
  end

end