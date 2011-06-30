require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "oci8_simple"
  gem.homepage = "http://github.com/unclebilly/oci8_simple"
  gem.license = "MIT"
  gem.summary = %Q{Command-line tools for interacting with an Oracle database.}
  gem.description = %Q{Command-line tools for interacting with an Oracle database. This client is intended to be used 
  to aid development and automation.  This is *not* meant to replace an ORM such as ActiveRecord + OracleEnhancedAdapter.
  The only prerequisite to running this code is that you have installed the ruby-oci8 gem on your machine.}
  gem.email = "billy.reisinger@gmail.com"
  gem.authors = ["Billy Reisinger"]
  gem.add_dependency "ruby-oci8", "~> 2.0.4"
  gem.extra_rdoc_files = ['README.rdoc']
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "oci8_simple #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
