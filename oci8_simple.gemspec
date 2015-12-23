require 'date'
Gem::Specification.new do |s|
  s.name = %q{oci8_simple}
  s.version = File.read(File.expand_path("../VERSION", __FILE__)).strip
  s.authors = ["Billy Reisinger"]
  s.date = Date.today
  s.description = %q{Command-line tools for interacting with an Oracle database. This client is intended to be used 
  to aid development and automation.  This is *not* meant to replace an ORM such as ActiveRecord + OracleEnhancedAdapter.
  The only prerequisite to running this code is that you have installed the ruby-oci8 gem on your machine.}
  s.email = %q{billy.reisinger@gmail.com}
  s.executables = ["oci8_simple", "show", "describe"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/describe",
    "bin/oci8_simple",
    "bin/show",
    "lib/oci8_simple.rb",
    "lib/oci8_simple/cli.rb",
    "lib/oci8_simple/client.rb",
    "lib/oci8_simple/command.rb",
    "lib/oci8_simple/config.rb",
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
  s.summary = %q{Command-line tools for interacting with an Oracle database.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-oci8>, ["> 2.1.2"])
    else
      s.add_dependency(%q<ruby-oci8>, ["> 2.1.2"])
    end
  else
    s.add_dependency(%q<ruby-oci8>, ["> 2.1.2"])
  end
end

