require File.join(File.dirname(__FILE__), 'helper')
class ShowTest < Test::Unit::TestCase
  def setup
    @client = Oci8Simple::Client.new("test")
    @show =   Oci8Simple::Show.new("test")
  end
  def teardown
    
  end
  context "Show tables" do
    setup do
      @client.run "drop table oci8_simple_test"   rescue nil
      @client.run "drop table oci8_simple_test_2" rescue nil
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST" ("ID" NUMBER(38,0) DEFAULT 7 NOT NULL ENABLE)
      SQL
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST_2" ("ID" NUMBER(38,0) NOT NULL ENABLE)
      SQL
    end
    should "list the tables" do
      assert_equal ["oci8_simple_test","oci8_simple_test_2"], @show.run("tables")
    end
  end
end