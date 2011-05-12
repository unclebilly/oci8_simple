#!/usr/bin/env ruby

require 'rubygems'
gem 'ruby-oci8'
require 'oci8'
require 'pp'
require 'bigdecimal'
require 'yaml'

# Run single statements against an arbitrary Oracle schema. This client is intended to be used by simple
# command-line scripts to aid automation.  This is *not* meant to replace an ORM such as ActiveRecord + OracleEnhancedAdapter.
# The only prerequisite to running this code is that you have installed the ruby-oci8 gem on your machine. 
# 
# == Installation
# [sudo] gem install oci8-simple
# 
# == Configuration
# To configure environments and schema settings, edit the 
# database.yml file in ~/.oci8_simple/
#   development:
#     database: oracle.hostname:1521/sid
#     username: foo_dev
#     password: OMG333
#   test:
#     database: oracle.hostname:1521/sid
#     username: foo_test
#     password: OMG333
# 
# == Logging
# All logging is done to ~/.oci8_simple/oci8_simple.log
# 
# == Examples 
# * Initialize a client against the development schema
#     client = Oci8Simple.new
# * Run a simple select query against development schema
#     client.run('select id, name from foos') => [[2, "lol"], [3, "hey"], ...]
# * Run a simple select query against stage schema
#     Oci8Simple.new("stage").run('select id, name from foos') => [[2, "lol"], [3, "hey"], ...]
# * Update something
#     client.run <<-SQL
#       UPDATE foos SET bar='baz' WHERE id=1233
#     SQL
# * Run some DDL
#     client.run <<-SQL
#       CREATE TABLE foos (
#          ID NUMBER(38) NOT NULL
#       )
#     SQL
# * Run some PL/SQL
#     client.run <<-SQL
#       DECLARE
#         a NUMBER;
#         b NUMBER;
#       BEGIN
#         SELECT e,f INTO a,b FROM T1 WHERE e>1;
#         INSERT INTO T1 VALUES(b,a);
#       END;
#     SQL
class Oci8Simple
  USER_DIR = File.join(ENV["HOME"], ".oci8_simple")
  CONFIG_FILE = File.join(USER_DIR, "database.yml")
  LOG_FILE = File.join(USER_DIR, "oci8_simple.log")
  
  attr_accessor :log_file, :puts_mode, :env
  
  # * env is the environment heading in your database.yml file
  # * uname is the username you want to use (defaults to config["username"])
  # * puts_mode is whether you want to format the result for printing to a terminal (defaults to false)
  def initialize(env="development", uname=nil, puts_mode=false)
    @env = env
    @uname = uname
    @puts_mode = puts_mode
    conn.autocommit = true
  end

  def log_file
    @log_file ||= File.open(LOG_FILE, 'a')
  end
  
  def run(sql)
    log(sql)
    result = []
    conn.exec(sql) do |r|
      row = []
      r.map do |col|
        if col.class == BigDecimal
          row << col.to_i
        elsif col.class == OCI8::CLOB
          row << col.read
        else
          row << col.to_s
        end
      end
      result << row
    end

    if @puts_mode
      result.map{|row| row.join(", ")}.join("\n")
    else
      if(result.length == 1 && result[0].length == 1)
        result[0][0]
      else
        result
      end
    end
  end
  
  def config
    @config ||= YAML.load_file(CONFIG_FILE)[@env]
  end
  
  private
    def conn
      @o ||= OCI8.new(@uname || config["username"], config["password"], config["database"])
    end
  
    def log(str)
      log_file.puts "#{Time.now} - #{@env} - #{str}"
    end
    
    def self.help
      <<-HELP
  Run arbitrary SQL against an Oracle schema. The default schema is the one defined
  in the development section of your ~/.oci8_simple/database.yml file.

  You do not need to include a semicolon to end a statement. The statement should be enclosed in single
  or double quotes. 

  Usage: #{$0} SQL [ENV]
  Example: #{$0} 'select id from users' stage
  HELP
    end
end 

if __FILE__ == $0
  if(["-h", "--help"].include?(ARGV[0]) || ARGV.empty?)
    Oci8Simple.help
  else
    sql = ARGV[0] || ""
    env = ARGV[1] || "development"
    Oci8Simple.new(env).run(sql)
  end
end