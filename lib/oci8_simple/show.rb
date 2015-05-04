module Oci8Simple
  ##
  # Examples: show tables
  #           show table users  # gets ddl for table
  #           show packages
  #           show package do_stuff # gets ddl for do_stuff
  #
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

    def run(type, thing = nil)
      if thing.nil?
        raise "Unknown type: #{type.inspect}" unless TYPES.has_key?(type)
        clazz = eval("OCI8::Metadata::#{TYPES[type]}")
        objects = client.send(:conn).describe_schema(client.config["username"]).all_objects.find_all{|f| f.class == clazz}
        objects.map(&:obj_name).map(&:downcase).sort
      else
        cursor = client.send(:conn).exec("SELECT dbms_metadata.get_ddl('#{type.upcase}', '#{thing.upcase}') from dual")
        result = cursor.fetch
        result[0] ? result[0].read : ""
      end
    end
    
    def initialize(env=nil)
      @env = env || "development"
    end
    
    def self.run_from_argv
      o = parse_options(self.usage)
      if(ARGV[0].nil?)
        puts o
      else
        puts self.new(@options[:environment]).run(*ARGV)
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
