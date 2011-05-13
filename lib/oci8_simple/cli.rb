module Oci8Simple
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