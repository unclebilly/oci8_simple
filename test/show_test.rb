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
  
  context "Show functions" do
    setup do
      @client.run "drop function oci8_simple_function" rescue nil
      @client.run <<-SQL
        CREATE FUNCTION oci8_simple_function 
        RETURN NUMBER 
        IS num NUMBER(1,0);
        BEGIN 
          SELECT 1 INTO num FROM DUAL;
          RETURN(num); 
        END
      SQL
    end
    should "list the functions" do
      assert_equal ["oci8_simple_function"], @show.run("functions")
    end
  end
  
  context "Show packages" do
    setup do
      @client.run "drop package oci8_simple_package" rescue nil
      @client.run <<-SQL
        CREATE OR REPLACE PACKAGE oci8_simple_package AS 
           FUNCTION something(id NUMBER, foo NUMBER) 
              RETURN NUMBER; 
        END oci8_simple_package
      SQL
    end
    should "list the packages" do
      assert_equal ["oci8_simple_package"], @show.run("packages")
    end
  end
  
  context "Show procedures" do
    setup do
      @client.run "drop procedure oci8_simple_procedure" rescue nil
      @client.run <<-SQL
        CREATE PROCEDURE oci8_simple_procedure AS
         BEGIN
            SELECT 1 FROM DUAL;
         END
      SQL
    end
    should "list the procedures" do
      assert_equal ["oci8_simple_procedure"], @show.run("procedures")
    end
  end
  
  context "Show sequences" do
    setup do
      @client.run "drop sequence oci8_simple_sequence" rescue nil
      @client.run <<-SQL
        CREATE SEQUENCE oci8_simple_sequence
      SQL
    end
    should "list the sequences" do
      assert_equal ["oci8_simple_sequence"], @show.run("sequences")
    end
  end
  
  context "show synonyms" do
    setup do
      @client.run "drop synonym oci8_simple_synonym" rescue nil
      @client.run <<-SQL
        CREATE SYNONYM oci8_simple_synonym 
           FOR DUAL
      SQL
    end
    should "list the synonyms" do
      assert_equal ["oci8_simple_synonym"], @show.run("synonyms")
    end
  end
  
  context "show types" do
    setup do
      @client.run "drop type oci8_simple_type" rescue nil
      @client.run <<-SQL
        CREATE TYPE oci8_simple_type AS OBJECT
          ( id  NUMBER(6))
      SQL
    end
    should "list the types" do
      assert_equal ["oci8_simple_type"], @show.run("types")
    end
  end
  
  context "show views" do
    setup do
      @client.run "drop view oci8_simple_view" rescue nil
      @client.run <<-SQL
        CREATE VIEW oci8_simple_view AS 
          SELECT sysdate AS dabba FROM DUAL
      SQL
    end
    should "list the views" do
      assert_equal ["oci8_simple_view"], @show.run("views")
    end
  end
end