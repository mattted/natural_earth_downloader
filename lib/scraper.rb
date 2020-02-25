class NEDL::Scraper

  NE_URL = "https://www.naturalearthdata.com/downloads/"

  def self.scrape_data_themes
    doc = Nokogiri::HTML(open(NE_URL))
    
    doc.css(".homeentry #block_container .home_block").each do |node|
      name = node.css("h3").text.split(",").first.strip
      scale = node.css("h3").text.split(",").last.strip.split(":").last
      desc = node.css("p").last.text.strip
      node.css("a").each do |link| 
        category = link.text.strip.downcase
        url = link.attr('href').split('/').last.strip
        new_scale = NEDL::DataTheme.new(name, scale, desc, category, url)
      end
    end
  end

  def self.scrape_file_list(theme)
    doc = Nokogiri::HTML(open(NE_URL + theme.url_add))
    binding.pry
  end

end