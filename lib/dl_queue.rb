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
    puts "Downloads currently in queue".blue
    puts "---------------------------------------------------"
    self.all.each do |download|
      puts "1:#{download.type.theme.scale} | #{download.type.name} - #{download.name} | #{download.size}".green
    end
    puts "---------------------------------------------------"
    puts ""
  end

  def self.download_queue

    puts "Enter the aboslute path where your files will be downloaded:".blue
    puts "Example: ".blue + "/home/[your_user_name]/Downloads/".green
    puts "Type ".blue + "abort".green + " to return to the main menu".blue
    path = gets.strip

    if path == "abort"
      return
    end

    if path[0] != "/" || path[-1] != "/"

      puts "Invalid path. It must begin and end with a /".red
      sleep(1)
      self.download_queue
    end

    puts "Downloading files...".blue

    self.all.each do |dl|
      tempfile = Down.download(dl.url)
      FileUtils.mv(tempfile.path, "#{path}#{tempfile.original_filename}")
      puts "#{tempfile.original_filename} downloaded...".green
    end

    puts ""
    puts "File downloads complete. Download queue cleared".blue
    puts ""
    sleep(1)

    self.all.clear
  end

end