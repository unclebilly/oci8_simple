module Oci8Simple
  module Command
    def self.inclued(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      # Returns an OptionParser object. 
      def parse_options(banner)
        o = OptionParser.new do |opt|
          opt.banner = banner
          opt.on("-v", "--version", "Show version") do
            puts "#{self.to_s} #{Oci8Simple::VERSION}"
            exit
          end
        end
        o.parse!
      end
      
    end
  end
end