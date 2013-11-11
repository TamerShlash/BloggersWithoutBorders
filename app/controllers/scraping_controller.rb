class ScrapingController < ApplicationController

  require 'open-uri'

  def show
  end

  def parse
    redirect_to root_path if params[:url].nil?

    @results = {}

    post_url = (URI.parse(params[:url]) rescue nil) || (URI.parse(URI.escape(params[:url])) rescue nil)
    post_url.scheme = 'http' if post_url.scheme.nil? # Prevent requesting local URIs

    html = Nokogiri::HTML(open(post_url.to_s).read)

    images = []
    html.css('*[id*=post-] img').each do |image|
      if image and image.attribute('src')
        image_url = (URI.parse(image.attribute('src')) rescue nil) ||
                    (URI.parse(URI.escape(image.attribute('src'))) rescue nil)
        image_url.scheme ||= post_url.scheme
        image_url.host ||= post_url.host
        image_url.port ||= post_url.port
        image_url.query = image_url.fragment = nil
        images.append image_url.to_s # ((image_url.scheme || 'http') + '://' + image_url.host + p + image_url.path)
      end
    end
    @results[:images] = images.uniq

    tags = []
    html.css('*[rel~=tag]').each { |tag| tags.append '#' + tag.inner_text.downcase.gsub(/[^[:alnum:]]/,' ').strip.gsub(/\s/,'_').gsub(/_{2,}/,'_') }
    @results[:tags] = tags.uniq.sort

    @title = "Analysis for: \"" + html.css('title').inner_text + "\""
    @results[:url] = post_url.to_s

  rescue Exception => e
    redirect_to '/', alert: 'A Problem has occurred, maybe the URL you entered is invalid. Please try again or report the problem.'
  end

end
