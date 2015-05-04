require File.join(File.dirname(__FILE__), 'helper')
class DescribeTest < Minitest::Test
  context "Given a table and some data" do
    setup do
      @client = Oci8Simple::Client.new("test")
      @client.run "DROP TABLE OCI8_SIMPLE_TEST CASCADE CONSTRAINTS" rescue nil
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST"
          (
            "NAME"           VARCHAR2(400 CHAR) DEFAULT 'FOO' NOT NULL ENABLE,
            "ID"             NUMBER(38,0) DEFAULT 7 NOT NULL ENABLE,
            "LONG_THING"     VARCHAR(2000 CHAR) DEFAULT '#{"a " * 50}' NOT NULL ENABLE,
            "TEXTS"          CLOB
          )
      SQL
      @describe = Oci8Simple::Describe.new("test")
    end
    context "describing a table" do
      setup do
      end
      should "format results for the command line" do
        expected=<<-STR
Required  Name        Type      Size    Char?  Char_size  Precision  Scale  Default   
--------------------------------------------------------------------------------------
       *  id          number    22.0                      38.0       0.0    7         
       *  long_thing  varchar2  4000.0  *      2000.0                       a a a a a ...
       *  name        varchar2  1600.0  *      400.0                        FOO       
          texts       clob                                                            
STR

        assert_equal(expected.chop, @describe.run("oci8_simple_test"))
      end
    end
  end
end