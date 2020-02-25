class NEDL::DataTheme

  attr_accessor :name, :scale, :desc, :category, :url_add
  @@all = []

  def initialize(name, scale, desc, category, url_add)
    @name = name
    @scale = scale
    @category = category
    @desc = desc
    @url_add = url_add
    @@all << self
  end

  def self.all
    @@all
  end

  def self.unique_scales
    self.all.map{ |theme| { "name" => theme.name, "scale" => theme.scale, "desc" => theme.desc } }.uniq
  end

end