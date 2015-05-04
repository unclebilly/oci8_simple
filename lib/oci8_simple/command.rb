module Oci8Simple
  module Command
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      # Returns an OptionParser object. 
      def parse_options(banner)
        @options= {:environment => "development"}
        o = OptionParser.new do |opt|
          opt.banner = banner
          opt.on("-c", "--show_column_names", "Show column names for each result") do
            @options[:hash] = true
          end
          opt.on("-e", "--environment ENV", "Set environment. Defaults to development") do |e|
            @options[:environment] = e
          end
          opt.on("-v", "--version", "Show version") do
            puts "#{self.to_s} #{Oci8Simple::VERSION}"
            exit
          end
        end
        o.parse!
        o
      end
      
    end
  end
end
