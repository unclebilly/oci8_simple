require 'rubygems'

require 'abbrev'
require 'bigdecimal'
require 'optparse'
require 'pp'
require 'yaml'

gem 'ruby-oci8'
require 'oci8'

require 'oci8_simple/config'
require 'oci8_simple/command'
require 'oci8_simple/cli'
require 'oci8_simple/client'
require 'oci8_simple/describe'
require 'oci8_simple/show'

module Oci8Simple
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
end