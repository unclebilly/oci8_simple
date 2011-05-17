require 'optparse'
module Oci8Simple
  # == Description
  # A very thin wrapper around Oci8Simple::Client that handles ARGV / options and
  # formats the output in a manner suitable for printing on the console
  # == Usage
  #   cli = Oci8Simple::Cli.new
  #   cli.run "select id, name from foos" # "3, Bacon\n5, Cheese Puffs\n..."
  class Cli
    attr_accessor :env, :client
    
    def initialize(env=nil)
      self.env = env
    end
    
    def run(sql)
      format(client.run(sql))
    end
    
    def format(arr)
      arr.map{|row| row.join(", ")}.join("\n")
    end
    
    def client
      @client ||= Client.new(env)
    end
    
    def self.usage
      "Usage: #{$0} \"SQL\" [ENV]"
    end
    
    def self.run_from_argv
      o = OptionParser.new do |opt|
        opt.banner = usage
        opt.on("-v", "--version", "Show version") do
          puts "version #{File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'))}"
          exit
        end
      end
      o.parse!
      if(ARGV[0].nil?)
        puts o
      else
        puts self.new(ARGV[1]).run(ARGV[0])
      end
    end
    
  end
end