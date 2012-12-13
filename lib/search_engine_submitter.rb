require 'search_engine_submitter/version'
require 'open-uri'

module SearchEngineSubmitter
  InvalidSitemapError = Class.new StandardError

  SEARCH_ENGINE_URL = {
    :google => 'http://www.google.com/webmasters/sitemaps/ping?sitemap=',
    :bing   => 'http://www.bing.com/webmaster/ping.aspx?siteMap='
    # Note - :yahoo uses :bing for webmaster tools now.
  }
  DEFAULT_ENGINES = [:google, :bing]

  class Submitter
    attr_reader :engines

    def initialize(*engine_list)
      @engines = get_engines_from engine_list
    end

    def engines=(*engine_list)
      @engines = get_engines_from engine_list
    end

    def submit_sitemap_url(url)
      engines.map { |engine| submit_url_to_search_engine url, engine }
    end
    alias_method :submit_rss_url, :submit_sitemap_url

    private

      def get_engines_from(engine_list)
        return DEFAULT_ENGINES if engine_list.empty?
        engine_list.map(&:to_sym).map{ |engine| engine == :yahoo ? :bing : engine }.uniq
      end

      def submit_url_to_search_engine(url, engine)
        begin
          return URI(SEARCH_ENGINE_URL[engine] + url.to_s).read
        rescue OpenURI::HTTPError => e
          raise InvalidSitemapError.new(e.message)
        end
      end
  end

  class << self
    def submit_sitemap_url(url, options={})
      submitter = Submitter.new
      submitter.engines = options[:to] if options[:to]
      submitter.submit_sitemap_url url
    end
    alias_method :submit_rss_url, :submit_sitemap_url
  end

  # Mixin for HTTP URIs
  module URISubmitter
    def submit_sitemap(options={})
      submitter(options).submit_sitemap_url self
    end
    alias_method :submit_rss, :submit_sitemap

    private

      def submitter(options={})
        @submitter ||= Submitter.new
        @submitter.engines = options[:to] if options[:to]
        @submitter
      end
  end
end

module URI
  class HTTP
    include SearchEngineSubmitter::URISubmitter
  end
end