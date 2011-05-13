module Oci8Simple
  # == Description
  # A very thin wrapper around Oci8Simple::Client that formats the output
  # as CSV (suitable for printing on the console)
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
  end
end