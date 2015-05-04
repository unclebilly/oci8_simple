module Oci8Simple
  class ConfigError < Exception; end
  class LogError < Exception; end
  
  # Run SQL and PL/SQL statements against an Oracle schema. 
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
  class Client
    USER_DIR = File.join(ENV["HOME"], ".oci8_simple")
    LOG_FILE_PATH = File.join(USER_DIR, "oci8_simple.log")
  
    attr_accessor :log_file, :log_file_path, :env
    
    def log_file_path
      @log_file_path || LOG_FILE_PATH
    end

    # * env is the environment heading in your database.yml file
    def initialize(env=nil)
      self.env = env || "development"
    end

    def log_file
      @log_file ||= File.open(log_file_path, 'a')
    rescue Errno::EACCES, Errno::ENOENT => e
      raise LogError.new("Cannot write to #{log_file_path}")
    end
  
    # sql - a query
    # options: 
    #   :hash => true|false - default is false - return an array of hashes (with column names) 
    #            instead of an array or arrays
    def run(sql, options={})
      log(sql)
      result = []
      if(options[:hash])
        fetch_hashes(sql) do |r|
          result << r
        end
      else
        fetch_arrays(sql) do |r|
          result << r
        end
      end
      result
    end
  
    def fetch_hashes(sql, &block)
      cursor = conn.exec(sql)
      col_names = cursor.get_col_names.map{|s| s.downcase.to_sym }
      while(r = cursor.fetch) do
        yield Hash[*col_names.zip(r.map {|col| record_to_string(col)}).flatten]
      end
      cursor.close
    end

    def fetch_arrays(sql, &block)
      conn.exec(sql) do |r|
        result = r.respond_to?(:map) ? r.map{|col| record_to_string(col)} : r
        yield result
      end
    end

    def record_to_string(record)
      if record.class == BigDecimal
        record.to_f
      elsif record.class == OCI8::CLOB
        record.read
      else
        record.to_s
      end
    end

    def config
      @config ||= Config.new[env]
    end
    
    # Create and return raw Oci8 connection
    def conn
      @conn ||= new_connection
    end
    
    private
    
    def new_connection
      c = OCI8.new(config["username"], config["password"], config["database"])
      c.autocommit = true
      c
    end
    
    def log(str)
      log_file.puts "#{Time.now} - #{@env} - #{str}"
    end
  end
end
