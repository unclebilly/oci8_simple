require File.join(File.dirname(__FILE__), 'helper')
class ShowTest < Minitest::Test
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
      assert((["oci8_simple_test", "oci8_simple_test_2"] - @show.run("tables")).empty?)
    end
  end
  
  context "Show functions" do
    setup do
      @fct = <<-SQL
        CREATE OR REPLACE FUNCTION \"#{@client.config["username"]}\".\"OCI8_SIMPLE_FUNCTION\"
        RETURN NUMBER 
        IS num NUMBER(1,0);
        BEGIN 
          SELECT 1 INTO num FROM DUAL;
          RETURN(num); 
        END
      SQL
      @client.run "drop function oci8_simple_function" rescue nil
      @client.run @fct
    end
    should "list the functions" do
      assert((["oci8_simple_function"] - @show.run("functions")).empty?)
    end
    should "show the function" do
      assert_equal @fct.gsub(/\s+/,' '), @show.run("function", "oci8_simple_function").gsub(/\s+/,' ')
    end
  end
  
  context "Show packages" do
    setup do
      @pkg = <<-SQL
        CREATE OR REPLACE PACKAGE \"#{@client.config["username"]}\".\"OCI8_SIMPLE_PACKAGE\" AS 
           FUNCTION something(id NUMBER, foo NUMBER) 
              RETURN NUMBER; 
        END OCI8_SIMPLE_PACKAGE
      SQL
      @client.run "drop package oci8_simple_package" rescue nil
      @client.run @pkg
    end
    should "list the packages" do
      assert((["oci8_simple_package"] - @show.run("packages")).empty?)
    end
    should "show the package" do
      assert_equal @pkg.gsub(/\s+/,' '), @show.run("package", "oci8_simple_package").gsub(/\s+/,' ')
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
      assert((["oci8_simple_procedure"] - @show.run("procedures")).empty?)
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
      assert((["oci8_simple_sequence"] - @show.run("sequences")).empty?)
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
      assert((["oci8_simple_synonym"] - @show.run("synonyms")).empty?)
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
      assert((["oci8_simple_type"] - @show.run("types")).empty?)
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
      assert((["oci8_simple_view"] - @show.run("views")).empty?)
    end
  end
end
