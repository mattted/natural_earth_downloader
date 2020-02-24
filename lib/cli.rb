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

    NEDL::DataScale.all.each.with_index(1) do |scale, i|
      puts "-----------------------------------------------------------------------"
      puts "(#{i})"
      puts "Name: #{scale.name.capitalize}"
      puts "Scale: 1:#{scale.scale}"
      puts "Description: #{scale.desc}"
    end
    puts "-----------------------------------------------------------------------"
    puts ""
    puts "Choose a the number of a suitable data theme from the options above:"
    
    # get_theme_choice
  end

end