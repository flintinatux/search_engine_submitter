require 'search_engine_submitter/version'
require 'open-uri'

module SearchEngineSubmitter
  SEARCH_ENGINE_URL = {
    :google => 'http://www.google.com/webmasters/sitemaps/ping?sitemap=',
    :yahoo  => 'http://www.bing.com/webmaster/ping.aspx?siteMap=',
    :bing   => 'http://www.bing.com/webmaster/ping.aspx?siteMap='
  }

  def self.submit_sitemap_url(url, options = { :to => :google })
    to = Array(options[:to]).map(&:to_sym)
    response = nil
    to.each do |engine|
      begin
        uri = URI(SEARCH_ENGINE_URL[engine] + url.to_s)
        response = uri.read
      rescue OpenURI::HTTPError
        raise SearchEngineSubmitter::InvalidSitemapError
      end
    end
    response
  end

  # Mixin for HTTP URIs
  module SubmitURI
    def submit_sitemap(options)
      SearchEngineSubmitter.submit_sitemap_url(self, options)
    end
  end

  class InvalidSitemapError < Exception
  end
end

module URI
  class HTTP
    include SearchEngineSubmitter::SubmitURI
  end
end