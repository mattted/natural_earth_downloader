class NEDL::DataScale

  attr_accessor :name, :scale, :desc, :themes
  @@all = []

  def initialize(name, scale, desc)
    @name = name
    @scale = scale
    @desc = desc
    @themes = []
    @@all << self
  end

  def self.all
    @@all
  end

  def add_theme(name)
    
  end

end