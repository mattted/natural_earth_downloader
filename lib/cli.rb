class NEDL::CLI

  def call
    puts "================================="
    puts "Natural Earth Project Initializer"
    puts "================================="

    list_main_menu
    main_menu_choice
  end

  def list_main_menu
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
      puts "2"
    when "3"
      puts "selected 3"
    when "exit"
      puts "exit"
    else
      puts "Invalid input"
      main_menu_choice
    end
  end

  def scale_menu
    puts ""
    puts "Available Data Scales"

    NEDL::Scraper.scrape_data_themes
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

    categories = NEDL::DataTheme.all.select{ |theme| theme.name == scale_name }

    categories.each.with_index(1) do |theme, i|
      puts "(#{i}) #{theme.category.capitalize} "
    end

    puts "-----------------------------------------------------------------------"

    get_category_choice(categories)
  end

  def get_category_choice(theme)
    puts "Please enter the number of the category you'd like to see data for: "
    choice = gets.strip.to_i

    if choice > theme.length || choice <= 0
      puts "Invalid input"
      get_category_choice(theme)
    end

    list_file_types(theme[choice - 1])
  end

  def list_file_types(theme)
    NEDL::Scraper.scrape_file_list(theme)
  end

end