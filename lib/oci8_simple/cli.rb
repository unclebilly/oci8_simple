module Oci8Simple
  # == Description
  # A very thin wrapper around Oci8Simple::Client that handles ARGV / options and
  # formats the output in a manner suitable for printing on the console
  # == Usage
  #   cli = Oci8Simple::Cli.new
  #   cli.run "select id, name from foos" # "3, Bacon\n5, Cheese Puffs\n..."
  class Cli
    include Command
    
    attr_accessor :env, :client
    
    def initialize(env=nil)
      self.env = env
    end
    
    def run(sql, options={})
      format(client.run(sql, options), options)
    end
    
    def format(arr, options)
      if(options[:hash])
        arr.map{|row| row.map{|k,v| "#{k}: #{v}"}.join("\n")}.join("\n\n")
      else
        arr.map{|row| row.join(", ")}.join("\n")
      end
    end
    
    def client
      @client ||= Client.new(env)
    end
    
    def self.usage
      "Usage: #{$0} [-e ENV] \"SQL\""
    end
    
    def self.run_from_argv
      o = parse_options(self.usage)
      if(ARGV[0].nil?)
        puts o
      else
        puts self.new(@options[:environment]).run(ARGV[0], @options)
      end
    end
    
  end
end
