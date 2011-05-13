require File.join(File.dirname(__FILE__), 'helper')
class CliTest < Test::Unit::TestCase
  context "The Cli" do
    setup do
      @client = Oci8Simple::Client.new("test")
      @client.run "DROP TABLE OCI8_SIMPLE_TEST CASCADE CONSTRAINTS" rescue nil
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST"
          (
            "ID"             NUMBER(38,0) NOT NULL ENABLE,
            "NAME"           VARCHAR2(400 CHAR) NOT NULL ENABLE,
            "TEXTS"          CLOB
          )
      SQL
      @client.run "INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (1, 'Johnny', 'OMG')"
      @client.run "INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (2, 'Jenny', 'OMG')"
      @cli = Oci8Simple::Cli.new("test")
    end
    should "format results for the command line" do
      assert_equal("1, Johnny, OMG\n2, Jenny, OMG", @cli.run("select * from oci8_simple_test"))
    end
  end
end