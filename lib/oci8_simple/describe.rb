module Oci8Simple
  # == Description
  # This class creates a string describing a table's columns, intended to be 
  # displayed in a fixed-width font.
  # == Usage
  #   Oci8Simple::Describe.new("development").run("users")
  class Describe
    include Command
    
    SPACE_BETWEEN=2
    FIELDS=[
      {:select => "NULLABLE",           :header => "Required", :content => :format_nullable, :right => true},
      {:select => "lower(COLUMN_NAME)", :header=> "Name"},
      {:select => "lower(DATA_TYPE)",   :header => "Type"},
      {:select => "DATA_LENGTH",        :header => "Size", :content => :format_size},
      {:select => "CHAR_USED",          :header => "Char?", :content => :format_char_used},   
      {:select => "CHAR_LENGTH",        :header => "Char_size", :content => :format_char_length},
      {:select => "DATA_PRECISION",     :header => "Precision"}, 
      {:select => "DATA_SCALE",         :header => "Scale"},
      {:select => "DATA_DEFAULT",       :header => "Default", :content => :format_default, :max => 10}
    ]
  
    def run(table)
      sql = <<-SQL
        select #{select_fields} 
        from user_tab_columns 
        where table_name='#{table.upcase}' 
        order by column_name asc
      SQL
      results = client.run(sql)
      calculate_widths(results)
      format_results(results)
    end
  
    def initialize(env=nil)
      @env = env || "development"
    end
  
    def self.usage
      "Usage: #{$0} TABLE_NAME [ENVIRONMENT]"
    end
  
    def self.run_from_argv
      o = parse_options(self.usage)
      if(ARGV[0].nil?)
        puts o
      else
        puts self.new(ARGV[1]).run(ARGV[0])
      end
    end
  
    private
  
    def format_nullable(value, row)
      value == 'N' ? '*' : ' '
    end

    def format_char_used(value, row)
      value == 'C' ? "*" : ' '
    end
  
    def format_char_length(value, row)
      row[FIELDS.index{|f| f[:select] == "CHAR_USED"}] == "C" ? value.to_s : ""
    end
  
    def format_size(value, row)
      row[FIELDS.index{|f| f[:select] == "lower(DATA_TYPE)"}] =~ /lob/i ? "" : value.to_s
    end
  
    def format_default(value, row)
      value = value.to_s.strip.gsub(/^'(.+)'$/,'\1')
    
      if(value.length > 10)
        value = value[0..9] + "..."
      end
      value
    end
  
    def select_fields
      FIELDS.map{|f| f[:select]}.join(",")
    end
  
    def max(column, header)
      max = header.length
      column.each {|s| max = s.length if s.length > max}
      max + SPACE_BETWEEN
    end

    def header
      FIELDS.map{|f| f[:header].ljust(f[:max], ' ')}.join("")
    end
  
    def calculate_widths(results)
      FIELDS.each_with_index do |hsh,i|
        if(hsh[:max].nil?)
          hsh[:max] = max(results.map{|row| row[i].to_s}, hsh[:header])
        end
      end
    end
  
    def format_results(results)
      arr = []
      arr << header
      arr << "-" * arr[0].length
      results.each do |result|
        str = ""
        result.each_with_index do |col, i|
          field = FIELDS[i]
          value = field[:content].nil? ? col.to_s : send(field[:content], col, result)
          if(field[:right])
            str << value.rjust(field[:max] - SPACE_BETWEEN, ' ')
            str << ' ' * SPACE_BETWEEN
          else
            str << value.ljust(field[:max], ' ')
          end
        end
        arr << str
      end
      arr.join("\n")
    end
  
    def client
      @client ||= Oci8Simple::Client.new(@env)
    end
  end
end