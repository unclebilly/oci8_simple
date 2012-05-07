require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "oci8_simple #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Build the gem from the .gemspec file"
task :build do
  system "gem build oci8_simple.gemspec"
end

desc "Release the gem to rubygems.org"
task :release => :build do
  version = File.read(File.expand_path("VERSION", __FILE__)).strip
  ourgem = "oci8_simple-#{version}.gem"
  system "gem push #{ourgem}"
end

