require File.join(File.dirname(__FILE__), 'helper')

class ClientTest < Minitest::Test
  context "A client" do
    setup do
      @client = Oci8Simple::Client.new
    end
    should "default to development environment" do
      assert_equal "development", @client.env
    end
    context "with a bad log file" do
      setup do
        @client.log_file_path = "/bridge/to/nowhere"
      end
      should "raise custom error" do
        assert_raises Oci8Simple::LogError do
          @client.log_file
        end
      end
    end
  end
  context "Running a procedure with nil return" do
    setup do
      @client = Oci8Simple::Client.new("test")
    end
    should "not raise an exception" do
      @client.run("SELECT NULL FROM DUAL")
    end
  end

  context "Given a table" do
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
      @client.run <<-SQL
        INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (1, 'Johnny', 'OMG')
      SQL
      @client.run <<-SQL
        INSERT INTO OCI8_SIMPLE_TEST (ID, NAME, TEXTS) VALUES (2, 'Jenny', 'OMG')
      SQL
    end
    context "the client" do
      should "be able to run a simple query with a single result" do
        assert_equal [[2]], @client.run("select count(*) from OCI8_SIMPLE_TEST")
      end
      should "be able to run a simple query with multiple results and multiple columns" do
        assert_equal [["1", "Johnny", "OMG"], ["2", "Jenny", "OMG"]], @client.run("select * from OCI8_SIMPLE_TEST")
      end
      should "be able to run a simple query with a single result and return a hash" do
        assert_equal [{:count => 2}], @client.run("select count(*) as count from OCI8_SIMPLE_TEST", :hash => true)
      end
    
      should "have logged something" do
        File.unlink(Oci8Simple::Client::LOG_FILE_PATH)
        assert(!File.exists?(Oci8Simple::Client::LOG_FILE_PATH))
        @client = Oci8Simple::Client.new("test")
        @client.run "select NULL from dual"
        @client.log_file.close
        assert(File.exists?(Oci8Simple::Client::LOG_FILE_PATH))
        assert(!(0 == File.size(Oci8Simple::Client::LOG_FILE_PATH)))
      end
    end
  end
end
