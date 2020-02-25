class NEDL::DataVector

  attr_accessor :name, :desc, :downloads, :theme
  @@all = []

  def initialize(name, desc, theme)
    @name = name
    @desc = desc
    @theme = theme
    @downloads = []
    @@all << self

    theme.files << self
  end

  def self.all
    @@all
  end

end