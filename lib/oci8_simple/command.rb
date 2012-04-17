module Oci8Simple
  module Command
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      # Returns an OptionParser object. 
      def parse_options(banner)
        @options= {}
        o = OptionParser.new do |opt|
          opt.banner = banner
          opt.on("-c", "--show_column_names", "Show column names for each result") do
            @options[:hash] = true
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