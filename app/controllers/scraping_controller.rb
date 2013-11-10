class ScrapingController < ApplicationController

  require 'open-uri'

  def show
  end

  def parse
    html = Nokogiri::HTML(open(params[:url]).read)

    @images = []
    html.css('img').each { |image| @images.append image.attribute('src') }
    @images.uniq!

    @tags = []
    html.css('*[rel~=tag]').each { |tag| @tags.append tag.inner_text }
    @tags.uniq!

  end
end
