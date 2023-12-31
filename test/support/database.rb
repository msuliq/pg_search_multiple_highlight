# frozen_string_literal: true

case RUBY_PLATFORM
when "java"
  require "activerecord-jdbc-adapter"
  ERROR_CLASS = ActiveRecord::JDBCError
else
  require "pg"
  ERROR_CLASS = PG::Error
end

begin
  # Configure connection options
  connection_options = {
    adapter: "postgresql",           # Use the PostgreSQL adapter
    host: "localhost",               # Host where the PostgreSQL server is running
    database: "pg_search_multiple_highlight_test", # Test database name
    min_messages: "warning",
    username: "postgres",
    password: ""
  }

  # If running in a CI environment, specify the username and password
  if ENV["CI"]
    connection_options[:username] = "postgres"
    connection_options[:password] = "postgres"
  end

  # Establish the database connection
  ActiveRecord::Base.establish_connection(connection_options)
  connection = ActiveRecord::Base.connection

  # Test the connection by executing a simple query
  connection.execute("SELECT 1")
rescue ERROR_CLASS, ActiveRecord::NoDatabaseError => e
  at_exit do
    puts "-" * 80
    puts "Unable to connect to the database. Please run:"
    puts
    puts "    createdb pg_search_multiple_highlight_test"
    puts "-" * 80
  end
  raise e
end

if ENV["LOGGER"]
  require "logger"
  ActiveRecord::Base.logger = Logger.new($stdout)
end

def install_extension(name)
  connection = ActiveRecord::Base.connection
  extension = connection.execute "SELECT * FROM pg_catalog.pg_extension WHERE extname = '#{name}';"
  return unless extension.none?

  connection.execute "CREATE EXTENSION #{name};"
rescue StandardError => e
  at_exit do
    puts "-" * 80
    puts "Please install the #{name} extension"
    puts "-" * 80
  end
  raise e
end

def install_extension_if_missing(name, query, expected_result)
  result = ActiveRecord::Base.connection.select_value(query)
  raise "Unexpected output for #{query}: #{result.inspect}" unless result.casecmp(expected_result).zero?
rescue StandardError
  install_extension(name)
end

install_extension_if_missing("pg_trgm", "SELECT 'abcdef' % 'cdef'", "t")
install_extension_if_missing("unaccent", "SELECT unaccent('foo')", "foo")
install_extension_if_missing("fuzzystrmatch", "SELECT dmetaphone('foo')", "f")

def load_sql(filename)
  connection = ActiveRecord::Base.connection
  file_contents = File.read(File.join(File.dirname(__FILE__), "..", "..", "sql", filename))
  connection.execute(file_contents)
end

load_sql("dmetaphone.sql")
