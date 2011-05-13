#!/usr/bin/env ruby


# Run single statements against an arbitrary Oracle schema. This client is intended to be used by simple
# command-line scripts to aid automation.  This is *not* meant to replace an ORM such as ActiveRecord + OracleEnhancedAdapter.
# The only prerequisite to running this code is that you have installed the ruby-oci8 gem on your machine. 
# 
# == Logging
# All logging is done to ~/.oci8_simple/oci8_simple.log
# 
# == Examples 
# * Initialize a client against the development schema
#     client = Oci8Simple::Client.new
# * Run a simple select query against development schema
#     client.run('select id, name from foos') => [[2, "lol"], [3, "hey"], ...]
# * Run a simple select query against stage schema
#     Oci8Simple:Client.new("stage").run('select id, name from foos') => [[2, "lol"], [3, "hey"], ...]
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
module Oci8Simple
  class Client
    USER_DIR = File.join(ENV["HOME"], ".oci8_simple")
    CONFIG_FILE = File.join(USER_DIR, "database.yml")
    LOG_FILE = File.join(USER_DIR, "oci8_simple.log")
  
    attr_accessor :log_file, :env
  
    # * env is the environment heading in your database.yml file
    def initialize(env=nil)
      self.env = env || "development"
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
      result
    end
  
    def config
      @config ||= YAML.load_file(CONFIG_FILE)[env]
    end
  
    private
    
    def conn
      @conn ||= OCI8.new(config["username"], config["password"], config["database"])
    end

    def log(str)
      log_file.puts "#{Time.now} - #{@env} - #{str}"
    end
  end
end