class NEDL::Scraper

  NE_URL = "https://www.naturalearthdata.com/downloads/"

  def self.scrape_data_themes
    if NEDL::DataTheme.all.length == 0
      doc = Nokogiri::HTML(open(NE_URL))
      
      doc.css(".homeentry #block_container .home_block").each do |node|
        name = node.css("h3").text.split(",").first.strip
        scale = node.css("h3").text.split(",").last.strip.split(":").last
        desc = node.css("p").last.text.strip

        node.css("a").each do |link| 
          category = link.text.strip.downcase
          url = link.attr('href').split('/').last.strip
          NEDL::DataTheme.new(name, scale, desc, category, url)
        end

      end
    end
  end

  def self.scrape_vector_file_list(theme)
    doc = Nokogiri::HTML(open(NE_URL + theme.url_add))
    
    doc.css(".download-entry").each do |data_vector|
      name = data_vector.css("h3").text
      desc = data_vector.css(".downloadPromoBlock em").text

      if NEDL::DataVector.all.detect { |vector| vector.name == name && vector.desc == desc } == nil
        new_vector = NEDL::DataVector.new(name, desc, theme)

        data_vector.css(".download-link-div").each do |download|
          name = download.css(".download-link").text
          url = download.css(".download-link").attr('href').text
          size = download.css(".download-link-span").text.split(")").first.split("(").last
          version = download.css(".download-link-span").text.split(" ").last
          type = new_vector

          NEDL::Download.new(name, size, version, type, url)
                  
        end
      end
    end
  end

  def self.scrape_raster_file_list(theme)
    doc = Nokogiri::HTML(open(NE_URL + theme.url_add))
  end

end