# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oci8_simple}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Billy Reisinger"]
  s.date = %q{2011-07-22}
  s.description = %q{Command-line tools for interacting with an Oracle database. This client is intended to be used 
  to aid development and automation.  This is *not* meant to replace an ORM such as ActiveRecord + OracleEnhancedAdapter.
  The only prerequisite to running this code is that you have installed the ruby-oci8 gem on your machine.}
  s.email = %q{billy.reisinger@gmail.com}
  s.executables = ["show", "oci8_simple", "describe"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/describe",
    "bin/oci8_simple",
    "bin/show",
    "lib/oci8_simple.rb",
    "lib/oci8_simple/cli.rb",
    "lib/oci8_simple/client.rb",
    "lib/oci8_simple/command.rb",
    "lib/oci8_simple/describe.rb",
    "lib/oci8_simple/show.rb",
    "oci8_simple.gemspec",
    "test/cli_test.rb",
    "test/client_test.rb",
    "test/describe_test.rb",
    "test/helper.rb",
    "test/show_test.rb"
  ]
  s.homepage = %q{http://github.com/unclebilly/oci8_simple}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Command-line tools for interacting with an Oracle database.}
  s.test_files = [
    "test/cli_test.rb",
    "test/client_test.rb",
    "test/describe_test.rb",
    "test/helper.rb",
    "test/show_test.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
    else
      s.add_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
    end
  else
    s.add_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<ruby-oci8>, ["~> 2.0.4"])
  end
end

