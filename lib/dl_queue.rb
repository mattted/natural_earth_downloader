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
    puts "-----------------------------------------------------------------------------------"
    if self.all == []
      puts "No downloads in queue".red
    else
      self.all.each do |download|
        if download.type.class == NEDL::DataVector
          filetype = "Vector"
          puts "#{filetype} | 1:#{download.type.theme.scale} | #{download.type.name} - #{download.name} | #{download.size}".green
        else
          filetype = "Raster"
          puts "#{filetype} | 1:#{download.type.category.theme.scale} | #{download.type.name} - #{download.name} | #{download.size}".green
        end
      end
    end
    puts "-----------------------------------------------------------------------------------"
    puts "Total size of files in queue: #{self.calculate_queue_filesize.round(2)} MB".blue
    puts ""
  end

  def self.download_queue

    if self.all == []
      puts ""
      puts "No downloads currently in queue".red
      puts ""
      return
    end

    puts ""
    puts "Enter the absolute path to the folder where your files will be downloaded:".blue
    puts "Example: ".blue + "/home/[your_user_name]/Downloads/".green
    puts "Type ".blue + "abort".green + " to return to the main menu".blue
    print ">>> "

    path = gets.strip

    if path == "abort"
      return
    end

    if path[0] != "/" || path[-1] != "/"
      puts ""
      puts "Invalid path. It must begin and end with a /".red
      puts ""
      sleep(1)
      self.download_queue
    else
      puts ""
      puts "Downloading files to ".blue + "#{path}".green

      self.all.each do |dl|
        progress_bar = nil
        tempfile = Down.download(dl.url,
          content_length_proc: proc { |total|
            if total.to_i > 0
              progress_bar = ProgressBar.create(title: 'Downloading', total: total)
            end
          },
          progress_proc: proc { |step|
            progress_bar.progress = step
          }
        )
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

  def self.calculate_queue_filesize
    total_size = 0
    
    self.all.each do |download|
      if download.size.split(" ").last.downcase == "kb"
        total_size += download.size.split(" ").first.to_f * 0.001
      else
        total_size += download.size.split(" ").first.to_f
      end        
    end

    total_size

  end

end