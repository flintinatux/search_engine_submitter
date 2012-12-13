require 'search_engine_submitter/version'
require 'open-uri'

module SearchEngineSubmitter
  InvalidSitemapError = Class.new StandardError
  NoSiteMapUrlError   = Class.new StandardError

  SEARCH_ENGINE_URL = {
    :google => 'http://www.google.com/webmasters/sitemaps/ping?sitemap=',
    :bing   => 'http://www.bing.com/webmaster/ping.aspx?siteMap='
    # Note - :yahoo uses :bing for webmaster tools now.
  }
  DEFAULT_ENGINES = { :to => [:google, :bing] }

  class Submitter
    attr_accessor :url

    def initialize(options = {})
      @url = options[:url]
    end

    def submit_sitemap(engine_list = DEFAULT_ENGINES)
      engines = get_engines_from engine_list
      engines.map { |engine| submit_url_to_search_engine engine }
    end
    alias_method :submit_rss, :submit_sitemap

    private

      def get_engines_from(engine_list)
        engines = Array(engine_list[:to]).map(&:to_sym)
        engines.map{ |to| to == :yahoo ? :bing : to }.uniq
      end

      def submit_url_to_search_engine(engine)
        raise NoSiteMapUrlError unless url
        begin
          return URI(SEARCH_ENGINE_URL[engine] + url.to_s).read
        rescue OpenURI::HTTPError
          raise SearchEngineSubmitter::InvalidSitemapError
        end
      end
  end

  class << self
    def submit_sitemap_url(url, engine_list = DEFAULT_ENGINES)
      submitter = Submitter.new :url => url
      submitter.submit_sitemap engine_list
    end
    alias_method :submit_rss_url, :submit_sitemap_url
  end

  # Mixin for HTTP URIs
  module SubmitURI
    def submit_sitemap(engine_list = DEFAULT_ENGINES)
      SearchEngineSubmitter.submit_sitemap_url(self, engine_list)
    end
    alias_method :submit_rss, :submit_sitemap
  end
end

module URI
  class HTTP
    include SearchEngineSubmitter::SubmitURI
  end
end