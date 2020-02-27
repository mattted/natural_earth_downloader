class NEDL::DataRaster

  attr_accessor :name, :desc, :downloads, :category
  @@all = []

  def initialize(name, desc, category)
    @name = name
    @desc = desc
    @category = category
    @downloads = []
    @@all << self
  end

  def self.all
    @@all
  end

end