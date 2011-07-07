module Oci8Simple
  class Show
    include Command
    
    TYPES={
      "functions" =>  "Function",
      "packages"  =>  "Package",
      "procedures" => "Procedure",
      "sequences" =>  "Sequence",
      "synonyms"  =>  "Synonym",
      "tables" =>     "Table",
      "types" =>      "Type",
      "views" =>      "View"
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
      o = parse_options(self.usage)
      if(ARGV[0].nil? || TYPES[ARGV[0]].nil?)
        puts o
      else
        puts self.new(ARGV[1]).run(ARGV[0])
      end
    end
    
    def self.usage
      <<-STR
Usage: #{$0} TYPE [ENVIRONMENT]

TYPE is one of: #{TYPES.keys.sort.join(", ")}
STR
    end
    
    private
    
    def client
      @client ||= Oci8Simple::Client.new(@env)
    end
  end
end