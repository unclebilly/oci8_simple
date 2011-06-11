class Oci8Simple::Describe
  def initialize(env=nil)
    @env = env || "development"
  end
  
  def run(table)
    description = client.conn.describe_table(table)
    description.columns.map(&:to_s).join("\n")
  end
  
  def self.usage
    "Usage: #{0} TABLE_NAME [ENVIRONMENT]"
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
  
  private
  
  def client
    @client ||= Oci8Simple::Client.new(@env)
  end
end