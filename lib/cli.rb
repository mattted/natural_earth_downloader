class NEDL::CLI

  def call
    system("clear")
    puts "=============================".blue
    puts "Natural Earth File Downloader".blue
    puts "=============================".blue

    list_main_menu
    main_menu_choice
  end

  def list_main_menu
    puts "Main Menu".blue
    puts "---------------------------------------------------"
    puts "(1)".red + " View and add files to download queue"
    puts "(2)".red + " View files in download queue"
    puts "(3)".red + " Download files in download queue"
    puts "---------------------------------------------------"
  end

  def main_menu_choice
    puts "Select a number from the options above or type ".blue + "exit".green
    main_menu_input = gets.chomp.strip.downcase
    
    case main_menu_input
    when "1"
      scale_menu
    when "2"
      NEDL::DLQueue.list
      sleep(1)
      list_main_menu
      main_menu_choice
    when "3"
      NEDL::DLQueue.download_queue
      list_main_menu
      main_menu_choice
    when "exit"
      puts "Quitting...".red
    else
      puts "Invalid input".red
      main_menu_choice
    end
  end

  def scale_menu
    puts ""
    puts "Available Data Scales".blue

    # Scrape and initialize the data theme objects found on the download page
    NEDL::Scraper.scrape_data_themes

    # Since scales/categories are both in DataTheme objects, and each combination
    # of a scale/category makes an object unique, a new hash must be created
    # containing only the unique scales in order to ask the user only their scale preference
    unique_scales = NEDL::DataTheme.unique_scales

    unique_scales.each.with_index(1) do |scale, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red
      puts "Name: #{scale["name"].capitalize}"
      puts "Scale: 1:#{scale["scale"]}"
      puts "Description: #{scale["desc"]}"
    end
    puts "-----------------------------------------------------------------------"

    get_scale_choice(unique_scales)
  end

  def get_scale_choice(scales)    
    puts "Please enter the number of the scale you'd like to see data for:".blue
    choice = gets.strip.to_i

    if choice > scales.length || choice <= 0
      puts "Invalid input".red
      get_scale_choice(scales)
    end

    list_categories(scales[choice - 1]["name"])
  end

  def list_categories(scale_name)
    puts ""
    puts "Available categories for #{scale_name}".blue
    puts "-----------------------------------------------------------------------"

    # get a selection of DataThemes that have the user selected scale
    themes = NEDL::DataTheme.all.select{ |theme| theme.name == scale_name }

    # puts the category of each theme that has the user selected scale
    themes.each.with_index(1) do |theme, i|
      puts "(#{i}) ".red + " #{theme.category.capitalize} "
    end

    puts "-----------------------------------------------------------------------"

    # passes the DataTheme objects with appropriate scales
    get_category_choice(themes)
  end

  def get_category_choice(themes)
    puts "Please enter the number of the category you'd like to see data for:".blue
    choice = gets.strip.to_i

    if choice > themes.length || choice <= 0
      puts "Invalid input".red
      get_category_choice(themes)
    end

    if themes[choice - 1].category == "cultural" || themes[choice - 1].category == "physical"

      # passes a single DataTheme based on user selection of scale and category
      NEDL::Scraper.scrape_vector_file_list(themes[choice - 1])
      list_vector_file_types(themes[choice - 1])
    else
      # passes a single DataTheme based on user selection of scale and category
      NEDL::Scraper.scrape_raster_categories(themes[choice - 1])
      list_raster_categories(themes[choice - 1])
    end
  end

  def list_vector_file_types(theme)
    puts ""
    puts "Files for #{theme.url_add.split("-").map{ |word| word.capitalize }.join(" ")}".blue
    vector_files = NEDL::DataVector.all.select do |file|
      file.theme == theme
    end

    vector_files.each.with_index(1) do |file, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red
      puts "Name: #{file.name}"
      puts "Description: #{file.desc}"
    end
    puts "-----------------------------------------------------------------------"
    
    get_file_choice(vector_files)
  end

  def get_file_choice(files)
    puts "Please enter the number of the file you'd like to see downloads for:".blue
    choice = gets.strip.to_i

    if choice > files.length || choice <= 0
      puts "Invalid input".red
      get_file_choice(files)
    end

    list_downloads(files[choice - 1])
  end

  def list_raster_categories(theme)
    puts ""
    puts "Files for #{theme.url_add.split("-").map{ |word| word.capitalize }.join(" ")}".blue
    raster_cats = NEDL::DataRasterCat.all.select do |category|
      category.theme == theme
    end

    raster_cats.each.with_index(1) do |category, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red
      puts "Name: #{category.name}"
      puts "Description: #{category.desc}"
    end
    puts "-----------------------------------------------------------------------"

    get_raster_category_choice(raster_cats)
  end

  def get_raster_category_choice(raster_cats)
    puts "Please enter the number of the category you'd like to see files for:".blue
    choice = gets.strip.to_i

    if choice > raster_cats.length || choice <= 0
      puts "Invalid input".red
      get_raster_category_choice(raster_cats)
    end

    NEDL::Scraper.scrape_raster_file_list(raster_cats[choice - 1])
    list_raster_file_types(raster_cats[choice - 1])
  end

  def list_raster_file_types(category)
    puts ""
    
    puts "Files for #{category.theme.scale} #{category.name}".blue
    raster_files = NEDL::DataRaster.all.select do |file|
      file.category == category
    end

    raster_files.each.with_index(1) do |file, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red
      puts "Name: #{file.name}"
      puts "Description: #{file.desc}"
    end
    puts "-----------------------------------------------------------------------"
    
    get_file_choice(raster_files)
  end
  

  def list_downloads(file)
    puts ""
    puts "Downloads for #{file.name}".blue

    download_list = NEDL::Download.all.select { |dl| dl.type == file }

    download_list.each.with_index(1) do |dl, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red + "  #{dl.name}"
      puts "Size: #{dl.size}   Version: #{dl.version}"
    end
    puts "-----------------------------------------------------------------------"

    get_download_choice(download_list)
  end

  def get_download_choice(download_list)
    puts "Enter the number of the download you'd like to add to your queue or".blue
    puts "type ".blue + "back".green + " to list the vector files again or".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue

    choice = gets.strip

    case choice
    when "back"
      list_vector_file_types(download_list.first.type.theme)
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i <= 0 || choice.to_i > download_list.length
        puts "Invalid input".red
        get_download_choice(download_list)
      end

      NEDL::DLQueue.add_to_queue(download_list[choice.to_i - 1]) if !NEDL::DLQueue.all.include?(download_list[choice.to_i - 1]) 
      puts ""
      puts "#{download_list[choice.to_i - 1].name} added to queue".green
      sleep(1)

      list_downloads(download_list.first.type)
    end
  end


end