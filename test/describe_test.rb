require File.join(File.dirname(__FILE__), 'helper')
class DescribeTest < Test::Unit::TestCase
  context "Given a table and some data" do
    setup do
      @client = Oci8Simple::Client.new("test")
      @client.run "DROP TABLE OCI8_SIMPLE_TEST CASCADE CONSTRAINTS" rescue nil
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST"
          (
            "NAME"           VARCHAR2(400 CHAR) NOT NULL ENABLE,
            "ID"             NUMBER(38,0) NOT NULL ENABLE,
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
"ID"    NUMBER(38)         NOT NULL
"NAME"  VARCHAR2(400 CHAR) NOT NULL
"TEXTS" CLOB               
STR
        assert_equal(expected.chop, @describe.run("oci8_simple_test"))
      end
    end
  end
end