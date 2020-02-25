class NEDL::DataTheme

  attr_accessor :name, :scale, :desc, :category
  @@all = []

  def initialize(name, scale, desc, category)
    @name = name
    @scale = scale
    @category = category
    @desc = desc
    @@all << self
  end

  def self.all
    @@all
  end

  def self.unique_scales
    self.all.map{ |theme| { "name" => theme.name, "scale" => theme.scale, "desc" => theme.desc } }.uniq
  end

end