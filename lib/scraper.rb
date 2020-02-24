class NEDL::Scraper

  NE_URL = "https://www.naturalearthdata.com/downloads/"

  def self.scrape_data_themes
    doc = Nokogiri::HTML(open(NE_URL))
    
    doc.css(".homeentry #block_container .home_block").each do |node|
      name = node.css("h3").text.split(",").first.strip
      scale = node.css("h3").text.split(",").last.strip.split(":").last
      data_types = node.css("a").map{ |a| a.text.strip.downcase }
      desc = node.css("p").last.text.strip

      NEDL::DataScale.new(name, scale, desc)

      data_types.each

    end

  end

end