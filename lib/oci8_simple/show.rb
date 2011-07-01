module Oci8Simple
  class Show
    TYPES={
      "tables" => "Table"
    }
    def run(type)
      clazz = eval("OCI8::Metadata::#{TYPES[type]}")
      objects = client.send(:conn).describe_schema(client.config["username"]).all_objects.find_all{|f| f.class == clazz}
      objects.map(&:obj_name).map(&:downcase).sort
    end
    
    def initialize(env=nil)
      @env = env || "development"
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
    
    def self.usage
      <<-STR
Usage: #{$0} TYPE [ENVIRONMENT]

Supported types: 
   functions
   packages
   procedures
   sequences
   synonyms
   tables
   types
   views   
STR
    end
    
    private
    
    def client
      @client ||= Oci8Simple::Client.new(@env)
    end
  end
end