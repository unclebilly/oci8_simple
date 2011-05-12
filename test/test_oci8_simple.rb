require 'helper'

class TestOci8Simple < Test::Unit::TestCase
  context "A client" do
    should "default to development environment" do
      @client = Oci8Simple.new
      assert_equal "development", @client.env
    end
  end
  context "Given a table" do
    setup do
      @client = Oci8Simple.new("test", nil, false)
      @client.run "DROP TABLE OCI8_SIMPLE_TEST CASCADE CONSTRAINTS" rescue nil
      @client.run <<-SQL
        CREATE TABLE "OCI8_SIMPLE_TEST"
          (
            "ID"             NUMBER(38,0) NOT NULL ENABLE,
            "NAME"           VARCHAR2(400 CHAR) NOT NULL ENABLE,
            "TEXTS"          CLOB
          )
      SQL
      @client.run <<-SQL
        INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (1, 'Johnny', 'OMG')
      SQL
      @client.run <<-SQL
        INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (2, 'Jenny', 'OMG')
      SQL
    end
    context "when puts mode is false the client" do
      setup do
      end
      should "be able to run a simple query with a single result" do
        assert_equal 2, @client.run("select count(*) from OCI8_SIMPLE_TEST")
      end
      should "be able to run a simple query with multiple results and multiple columns" do
        assert_equal [["1", "Johnny", "OMG"], ["2", "Jenny", "OMG"]], @client.run("select * from OCI8_SIMPLE_TEST")
      end
    
      should "have logged something" do
        File.unlink(Oci8Simple::LOG_FILE)
        assert(!File.exists?(Oci8Simple::LOG_FILE))
        @client = Oci8Simple.new("test", nil, false)
        @client.run "select NULL from dual"
        @client.log_file.close
        assert(File.exists?(Oci8Simple::LOG_FILE))
        assert(!(0 == File.size(Oci8Simple::LOG_FILE)))
      end
    end
    context "when puts mode is true the client" do
      setup do
        @client.puts_mode = true
      end
      should "format result" do
        result = @client.run("select * from OCI8_SIMPLE_TEST")
        assert_equal "1, Johnny, OMG\n2, Jenny, OMG", result
      end
    end
  end
end
