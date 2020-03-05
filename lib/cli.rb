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
    print ">>> "
    main_menu_input = gets.chomp.strip.downcase
    
    case main_menu_input
    when "1"
      scale_menu
    when "2"
      NEDL::DLQueue.list
      # sleep(1)
      list_main_menu
      main_menu_choice
    when "3"
      NEDL::DLQueue.download_queue
      list_main_menu
      main_menu_choice
    when "exit"
      puts "Quitting...".red
      exit!
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

    # Passes the unique scale hashes to #get_scale_choice
    get_scale_choice(unique_scales)
  end

  def get_scale_choice(scales)    
    puts "Please enter the number of the scale you'd like to see data for:".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue
    print ">>> "
    choice = gets.strip

    case choice
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i > scales.length || choice.to_i <= 0
        puts "Invalid input".red
        get_scale_choice(scales)
      end

      # Passes the name of the DataTheme to #list_categories
      list_categories(scales[choice.to_i - 1]["name"])
    end
  end

  def list_categories(scale_name)
    puts ""
    puts "Available categories for #{scale_name}".blue
    puts "-----------------------------------------------------------------------"

    # get a selection of DataThemes that have the user selected scale
    themes = NEDL::DataTheme.all.select{ |theme| theme.name == scale_name }

    # puts the categories of the themes that have the user selected scale
    themes.each.with_index(1) do |theme, i|
      puts "(#{i}) ".red + " #{theme.category.capitalize} "
    end

    puts "-----------------------------------------------------------------------"

    # passes the DataTheme objects with the user selected scales
    get_category_choice(themes)
  end

  def get_category_choice(themes)
    puts "Please enter the number of the category you'd like to see data for:".blue
    puts "type ".blue + "back".green + " to show the previous list again or".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue
    print ">>> "
    choice = gets.strip

    case choice
    when "back"
      scale_menu
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i > themes.length || choice.to_i <= 0
        puts "Invalid input".red
        get_category_choice(themes)
      end

      if themes[choice.to_i - 1].category == "cultural" || themes[choice.to_i - 1].category == "physical"

        # passes a single DataTheme instance based on user selection of scale and category
        NEDL::Scraper.scrape_vector_file_list(themes[choice.to_i - 1])
        list_vector_file_types(themes[choice.to_i - 1])
      else
        # passes a single DataTheme instance based on user selection of scale and category
        NEDL::Scraper.scrape_raster_categories(themes[choice.to_i - 1])
        list_raster_categories(themes[choice.to_i - 1])
      end
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
    
    # called with vector_files to pass along the vector files with the user selected theme
    get_file_choice(vector_files)
  end

  def get_file_choice(files)
    puts "Enter the number of the file you'd like to view info for or".blue
    puts "type ".blue + "back".green + " to show the previous list again or".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue
    print ">>> "
    choice = gets.strip

    case choice
    when "back"
      if files.first.class == NEDL::DataVector
        list_categories(files.first.theme.name)
      else
        list_raster_categories(files.first.category.theme)
      end
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i > files.length || choice.to_i <= 0
        puts "Invalid input".red
        get_file_choice(files)
      end

      # pass the user selected instance of DataVector or DataRaster as argument
      list_downloads(files[choice.to_i - 1])
    end
  end

  def list_raster_categories(theme)
    puts ""
    puts "Categories for #{theme.url_add.split("-").map{ |word| word.capitalize }.join(" ")}".blue

    # store the DataRasterCat instances with the user selected theme that was passed in
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

    # pass the DataRasterCat instances with the user selected theme
    get_raster_category_choice(raster_cats)
  end

  def get_raster_category_choice(raster_cats)
    puts "Please enter the number of the category you'd like to see files for:".blue
    puts "type ".blue + "back".green + " to list the files again or".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue
    print ">>> "
    choice = gets.strip

    case choice
    when "back"
      list_categories(raster_cats.first.theme.name)
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i > raster_cats.length || choice.to_i <= 0
        puts "Invalid input".red
        get_raster_category_choice(raster_cats)
      end

      # call with user selected DataRasterCat instance
      NEDL::Scraper.scrape_raster_file_list(raster_cats[choice.to_i - 1])
      list_raster_file_types(raster_cats[choice.to_i - 1])
    end
  end

  def list_raster_file_types(category)
    puts ""
    
    puts "Files for #{category.theme.scale} #{category.name}".blue

    # create a selection of only the DataRaster instances with the user selected category
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
    
    # pass the selection of DataRaster instances with the user selected category
    get_file_choice(raster_files)
  end
  

  def list_downloads(file)
    puts ""
    puts "Downloads for #{file.name}".blue

    # selection of Download instances with the user selected file type
    download_list = NEDL::Download.all.select { |dl| dl.type == file }

    download_list.each.with_index(1) do |dl, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})".red + "  #{dl.name}"
      puts "Size: #{dl.size}   Version: #{dl.version}"
    end
    puts "-----------------------------------------------------------------------"
    puts ""

    # pass the list of Download instances with the appropriate file type as an argument
    get_download_choice(download_list)
  end

  def get_download_choice(download_list)
    puts "Enter the number of the download you'd like to add to your queue or".blue
    puts "type ".blue + "back".green + " to list the files again or".blue
    puts "type ".blue + "main".green + " to go back to the main menu".blue
    print ">>> "
 
    choice = gets.strip

    case choice
    when "back"
      if download_list.first.type.class == NEDL::DataVector
        list_vector_file_types(download_list.first.type.theme)
      else
        list_raster_file_types(download_list.first.type.category)
      end
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i <= 0 || choice.to_i > download_list.length
        puts "Invalid input".red
        get_download_choice(download_list)
      end

      # add a Download instance if it is not already in the DLQueue.all array
      NEDL::DLQueue.add_to_queue(download_list[choice.to_i - 1]) if !NEDL::DLQueue.all.include?(download_list[choice.to_i - 1]) 
      puts ""
      puts "#{download_list[choice.to_i - 1].name} added to queue".green
      # sleep(1)

      list_downloads(download_list.first.type)
    end
  end


end