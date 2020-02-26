class NEDL::DLQueue

  @@all = []

  def self.all
    @@all
  end

  def self.add_to_queue(download)
    @@all << download
  end

  def self.list
    puts ""
    puts "Downloads currently in queue"
    puts "---------------------------------------------------"
    self.all.each do |download|
      puts "1:#{download.type.theme.scale} | #{download.type.name} - #{download.name} | #{download.size}"
    end
    puts "---------------------------------------------------"
    puts ""
  end


end