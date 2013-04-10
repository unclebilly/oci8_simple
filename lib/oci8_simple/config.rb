module Oci8Simple
  ##
  # Config will look in three places for your database.yml file. Here is the order: 
  #   Dir.pwd + database.yml
  #   Dir.pwd + config/database.yml
  #   ~/.oci8_simple/database.yml
  #
  class Config
    USER_DIR = File.join(ENV["HOME"], ".oci8_simple")

    def [](key)
      @raw_config[key]
    end

    def initialize
      load_yaml 
    end

    def database_yaml_path
      path = File.join(Dir.pwd, "database.yml")
      return path if File.exists?(path)
      path = File.join(Dir.pwd, "config", "database.yml")
      return path if File.exists?(path)
      File.join(USER_DIR, "database.yml")
    end

    def load_yaml
      begin
        @raw_config = YAML.load_file(database_yaml_path)
      rescue Errno::ENOENT => e
        raise ConfigError.new <<-ERR
File #{CONFIG_FILE} doesn't exist - use the following template:

environment:
  database: 192.168.1.3:1521/sid
  username: foo_user
  password: foobar

ERR
      end
    end
  end
end