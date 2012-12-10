# SearchEngineSubmitter

A tool to make the submission of sitemaps and RSS/Atom feeds to search engines as painless as possible. Use it to notify Big-G and friends of updates to your blog, or to ping newly created backlinks for your latest SEO campaign.

## Installation

Add this line to your application's Gemfile:

    gem 'search_engine_submitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_engine_submitter

## Usage

To submit a sitemap or RSS feed url to all three major search engines:

```ruby
require 'search_engine_submitter'

my_sitemap = 'http://testdomain.com/sitemap.xml'
SearchEngineSubmitter.submit_sitemap_url my_sitemap
```

Use the `:to` option to specify which search engines you want for submittal. You can choose from `:google`, `:yahoo`, or `:bing`.

```ruby
SearchEngineSubmitter.submit_sitemap_url my_sitemap, :to => [:google, :yahoo]
```

You can also submit a URI:

```ruby
my_sitemap_uri = URI(my_sitemap)
SearchEngineSubmitter.submit_sitemap_url my_sitemap_uri
```

Or even submit a URI directly:

```ruby
my_sitemap_uri.submit_sitemap :to => :google
```

All search engines consider RSS or Atom feeds to be acceptable formats for sitemaps, so if it makes your code more syntactically aesthetic, then you can use the RSS alias methods instead:

```ruby
my_rss_feed = 'http://testdomain.com/rss'
SearchEngineSubmitter.submit_rss_url my_rss_feed, :to => :yahoo
URI(my_rss_feed).submit_rss :to => [:google, :bing]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
