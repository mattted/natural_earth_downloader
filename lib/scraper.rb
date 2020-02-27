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

  def self.scrape_raster_categories(theme)
    doc = Nokogiri::HTML(open(NE_URL + theme.url_add))

    doc.css(".post .entry table tr td").each do |raster_cat|
      name = raster_cat.css("h3").text
      desc = raster_cat.css("p").text
      url = self.url_parser(raster_cat.css("a").attr("href").text) if raster_cat.css("a").attr("href") != nil

      if NEDL::DataRasterCat.all.detect{ |category| category.name == name && category.desc == desc } == nil && name != ""
        NEDL::DataRasterCat.new(name, desc, url, theme)
      end
    end

  end

  def self.scrape_raster_file_list(category)
    doc = Nokogiri::HTML(open(NE_URL + category.url_add))

    doc.css(".download-entry").each do |data_raster|
      name = data_raster.css("h3").text
      desc = data_raster.css(".downloadPromoBlock em").text

      if NEDL::DataRaster.all.detect { |raster| raster.name == name && raster.desc == desc } == nil
        new_raster = NEDL::DataRaster.new(name, desc, category)

        data_raster.css(".download-link-div").each do |download|
          name = download.css(".download-link").text
          url = download.css(".download-link").attr('href').text
          size = download.css(".download-link-span").text.split(")").first.split("(").last
          version = download.css(".download-link-span").text.split(" ").last
          type = new_raster

          NEDL::Download.new(name, size, version, type, url)
                  
        end
      end
    end
  end

  def self.url_parser(url)

    url_arr = url.split("/")
    url_arr[(url_arr.index("downloads") + 1)..-1].join("/")

  end

end