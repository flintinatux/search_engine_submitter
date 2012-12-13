# SearchEngineSubmitter  [![Build Status](https://secure.travis-ci.org/flintinatux/search_engine_submitter.png)](http://travis-ci.org/flintinatux/search_engine_submitter) [![Dependency Status](https://gemnasium.com/flintinatux/search_engine_submitter.png)](https://gemnasium.com/flintinatux/search_engine_submitter) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/flintinatux/search_engine_submitter)

A tool to make the submission of sitemaps and RSS/Atom feeds to search engines as painless as possible. Use it to notify Big-G and friends of updates to your blog, or to ping newly created backlinks for your latest SEO campaign.

## Installation

Add this line to your application's Gemfile:

    gem 'search_engine_submitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_engine_submitter

## Changes

The latest update introduced a breaking change by switching from class methods to object methods. The new changes will make it much easier to test, use, and maintain. Sorry for any inconvience! See Usage below for details on the new syntax.

## Usage

To submit a sitemap or RSS feed url to all three major search engines:

```ruby
require 'search_engine_submitter'
my_sitemap = 'http://testdomain.com/sitemap.xml'
submitter = SearchEngineSubmitter::Submitter.new
submitter.submit_sitemap_url my_sitemap
```

You can also specify the search engines you want. Choose from any combination of `:google`, `:yahoo`, and `:bing`. You can even submit a URI:

```ruby
submitter = SearchEngineSubmitter::Submitter.new(:engines => [:google, :yahoo])
submitter.submit_sitemap_url my_sitemap

# or...

submitter.engines = [:bing]
submitter.submit_sitemap_url URI(my_sitemap)
```

You can also submit a URI directly. Use the `:to` option to specify your preferred engines.

```ruby
my_sitemap_uri.submit_sitemap :to => :google
```

All search engines consider RSS or Atom feeds to be acceptable formats for sitemaps, so if it makes your code more syntactically aesthetic, then you can use the RSS alias methods instead:

```ruby
my_rss_feed = 'http://testdomain.com/rss'
submitter.submit_rss_url my_rss_feed
URI(my_rss_feed).submit_rss
```

The return value of all of these methods is an array of [OpenURI::Meta](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open-uri/rdoc/OpenURI/Meta.html) objects containing the response of each search engine submittal.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
