require 'search_engine_submitter/version'
require 'open-uri'

module SearchEngineSubmitter
  SEARCH_ENGINE_URL = {
    :google => 'http://www.google.com/webmasters/sitemaps/ping?sitemap=',
    :bing   => 'http://www.bing.com/webmaster/ping.aspx?siteMap='
    # Note - :yahoo uses :bing for webmaster tools now.
  }

  DEFAULT_OPTIONS = { :to => [:google, :bing] }

  class << self
    def submit_sitemap_url(url, options = DEFAULT_OPTIONS)
      to = Array(options[:to]).map(&:to_sym)
      to = to.map!{ |to| to == :yahoo ? :bing : to }.uniq
      responses = []
      to.each do |engine|
        begin
          uri = URI(SEARCH_ENGINE_URL[engine] + url.to_s)
          responses << uri.read
        rescue OpenURI::HTTPError
          raise SearchEngineSubmitter::InvalidSitemapError
        end
      end
      responses
    end
    alias_method :submit_rss_url, :submit_sitemap_url
  end


  # Mixin for HTTP URIs
  module SubmitURI
    def submit_sitemap(options = DEFAULT_OPTIONS)
      SearchEngineSubmitter.submit_sitemap_url(self, options)
    end
    alias_method :submit_rss, :submit_sitemap
  end

  class InvalidSitemapError < Exception
  end
end

module URI
  class HTTP
    include SearchEngineSubmitter::SubmitURI
  end
end