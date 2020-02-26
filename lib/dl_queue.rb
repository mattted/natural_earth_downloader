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

  def self.download_queue

    puts "Enter a path where your files will be downloaded:"
    path = gets.strip

    self.all.each do |dl|
      tempfile = Down.download(dl.url)
      FileUtils.mv(tempfile.path, "#{path}#{tempfile.original_filename}")
      puts "#{tempfile.original_filename} downloaded..."
    end

    puts ""
    puts "File downloads complete. Download queue cleared"
    puts ""

    self.all.clear
  end

end