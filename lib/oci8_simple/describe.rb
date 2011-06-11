class Oci8Simple::Describe
  def initialize(env=nil)
    @env = env || "development"
  end
  
  def run(table)
    description = client.conn.describe_table(table)
    c = description.columns.sort{|a,b| a.name <=> b.name }
    max_name = max(c.map(&:name)) + 3
    max_type = max(c.map {|col| type_and_size(col)}) + 1
    c.map do |col|
      "\"#{col.name}\"".ljust(max_name, ' ') + type_and_size(col).ljust(max_type, ' ') + null(col)
    end.map(&:upcase).join("\n")
  end
  
  def null(col)
    col.nullable? ? "" : "NOT NULL"
  end
  
  def type_and_size(col)
    str = "#{col.data_type}"
    if(col.data_type.to_s =~ /varchar/i)
      str << "(#{col.char_size} CHAR)"
    elsif(col.data_type == :number)
      str << "(#{col.precision})"
    end
    str
  end
  
  def max(arr)
    arr.map(&:length).max
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