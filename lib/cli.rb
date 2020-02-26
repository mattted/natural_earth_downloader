class NEDL::CLI

  def call
    puts "================================="
    puts "Natural Earth Project Initializer"
    puts "================================="

    list_main_menu
    main_menu_choice
  end

  def list_main_menu
    puts "Main Menu"
    puts "---------------------------------------------------"
    puts "(1) Add files to download queue"
    puts "(2) View files in download queue"
    puts "(3) Download files in download queue"
    puts "---------------------------------------------------"
  end

  def main_menu_choice
    puts "Select a number from the options above or type exit"
    main_menu_input = gets.chomp.strip.downcase
    
    case main_menu_input
    when "1"
      scale_menu
    when "2"
      NEDL::DLQueue.list
      list_main_menu
      main_menu_choice
    when "3"
      NEDL::DLQueue.download_queue
      list_main_menu
      main_menu_choice
    when "exit"
      puts "Quitting..."
    else
      puts "Invalid input"
      main_menu_choice
    end
  end

  def scale_menu
    puts ""
    puts "Available Data Scales"

    # Scrape and initialize the data theme objects found on the download page
    NEDL::Scraper.scrape_data_themes

    # Since scales/categories are both in DataTheme objects, and each combination
    # of a scale/category makes an object unique, a new hash must be created
    # containing only the unique scales in order to ask the user only their scale preference
    unique_scales = NEDL::DataTheme.unique_scales

    unique_scales.each.with_index(1) do |scale, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})"
      puts "Name: #{scale["name"].capitalize}"
      puts "Scale: 1:#{scale["scale"]}"
      puts "Description: #{scale["desc"]}"
    end
    puts "-----------------------------------------------------------------------"

    get_scale_choice(unique_scales)
  end

  def get_scale_choice(scales)    
    puts "Please enter the number of scale you'd like to see data for: "
    choice = gets.strip.to_i

    if choice > scales.length || choice <= 0
      puts "Invalid input"
      get_scale_choice(scales)
    end

    list_categories(scales[choice - 1]["name"])
  end

  def list_categories(scale_name)
    puts ""
    puts "Available categories for #{scale_name}"
    puts "-----------------------------------------------------------------------"

    # get a selection of DataThemes that have the user selected scale
    themes = NEDL::DataTheme.all.select{ |theme| theme.name == scale_name }

    # puts the category of each theme that has the user selected scale
    themes.each.with_index(1) do |theme, i|
      puts "(#{i}) #{theme.category.capitalize} "
    end

    puts "-----------------------------------------------------------------------"

    # passes the DataTheme objects with appropriate scales
    get_category_choice(themes)
  end

  def get_category_choice(themes)
    puts "Please enter the number of the category you'd like to see data for: "
    choice = gets.strip.to_i

    if choice > themes.length || choice <= 0
      puts "Invalid input"
      get_category_choice(themes)
    end

    if themes[choice - 1].category == "cultural" || themes[choice - 1].category == "physical"

      # passes a single DataTheme based on user selection of scale and category
      NEDL::Scraper.scrape_vector_file_list(themes[choice - 1])
      list_vector_file_types(themes[choice - 1])
    else
      # passes a single DataTheme based on user selection of scale and category
      NEDL::Scraper.scrape_raster_file_list(themes[choice - 1])
      list_raster_file_types(themes[choice - 1])
    end
  end

  def list_vector_file_types(theme)
    puts ""
    puts "Files for #{theme.url_add.split("-").map{ |word| word.capitalize }.join(" ")}".upcase
    
    vector_files = NEDL::DataVector.all.select do |file|
      file.theme == theme
    end

    vector_files.each.with_index(1) do |file, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})"
      puts "Name: #{file.name}"
      puts "Description: #{file.desc}"
    end
    puts "-----------------------------------------------------------------------"
    
    get_file_choice(vector_files)
  end

  def get_file_choice(vector_files)
    puts "Please enter the number of the file you'd like to see downloads for:"
    choice = gets.strip.to_i

    if choice > vector_files.length || choice <= 0
      puts "Invalid input"
      get_file_choice(vector_files)
    end

    list_downloads(vector_files[choice - 1])
  end

  def list_downloads(vector_file)
    puts ""
    puts "Downloads for #{vector_file.name}"

    download_list = NEDL::Download.all.select { |dl| dl.type == vector_file }

    download_list.each.with_index(1) do |dl, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})  #{dl.name}"
      puts "Size: #{dl.size}   Version: #{dl.version}"
    end
    puts "-----------------------------------------------------------------------"

    get_download_choice(download_list)
  end

  def get_download_choice(download_list)
    puts "Enter the number of the download you'd like to add to your queue or"
    puts "type 'back' to list the vector files again or"
    puts "type 'main' to go back to the main menu"

    choice = gets.strip

    case choice
    when "back"
      list_vector_file_types(download_list.first.type.theme)
    when "main"
      list_main_menu
      main_menu_choice
    else
      if choice.to_i <= 0 || choice.to_i > download_list.length
        puts "Invalid input IS THIS IT"
        get_download_choice(download_list)
      end

      NEDL::DLQueue.add_to_queue(download_list[choice.to_i - 1]) if !NEDL::DLQueue.all.include?(download_list[choice.to_i - 1]) 
      puts ""
      puts "#{download_list[choice.to_i - 1].name} added to queue"
      puts ""

      list_downloads(download_list.first.type)
    end
  end


end