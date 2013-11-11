class ScrapingController < ApplicationController

  require 'open-uri'

  def show
  end

  def parse
    if params[:url].nil?
      redirect_to root_path
    end
    html = Nokogiri::HTML(open(params[:url]).read)

    @images = []
    html.css('*[id*=post-] img').each do |image|
      if image and image.attribute('src')
        parsed_url = URI.parse(image.attribute('src'))
        p = ((parsed_url.port == 80 or parsed_url.port == 443)? '' : parsed_url.port.to_s)
        @images.append ((parsed_url.scheme || 'http') + '://' + parsed_url.host + p + parsed_url.path)
      end
    end
    @images.uniq!

    @tags = []
    html.css('*[rel~=tag]').each { |tag| @tags.append '#' + tag.inner_text.downcase.gsub(/[^[:alnum:]]/,' ').strip.gsub(/\s/,'_').gsub(/_{2,}/,'_') }
    @tags = @tags.uniq.sort
  end
end
