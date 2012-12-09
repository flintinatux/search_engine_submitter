# -*- encoding: utf-8 -*-
require File.expand_path('../lib/search_engine_submitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Scott McCormack"]
  gem.email         = ["mail@madhackerdesigns.com"]
  gem.description   = %q{A tool to make the submission of sitemaps and RSS/Atom feeds to search engines as painless as possible. Use it to notify Big-G and friends of updates to your blog, or to ping newly created backlinks for your latest SEO campaign.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/flintinatux/search_engine_submitter"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "search_engine_submitter"
  gem.require_paths = ["lib"]
  gem.version       = SearchEngineSubmitter::VERSION
  
  gem.add_development_dependency 'rspec', '~> 2.12.0'
end
