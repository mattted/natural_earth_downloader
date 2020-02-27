class NEDL::DataRasterCat

  attr_accessor :name, :desc, :theme
  @@all = []

  def initialize(name, desc, theme)
    @name = name
    @desc = desc
    @theme = theme
    @@all << self
  end

  def self.all
    @@all
  end

end