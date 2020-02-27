class NEDL::DataRaster

  attr_accessor :name, :desc, :category
  @@all = []

  def initialize(name, desc, category)
    @name = name
    @desc = desc
    @category = category
    @@all << self
  end

  def self.all
    @@all
  end

end