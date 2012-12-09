#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |r|
  r.rspec_opts = '--color --format documentation'
end
task :default => :spec

namespace :gem do
  require "bundler/gem_tasks"
end
