# frozen_string_literal: true

require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "minitest/autorun"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pg_search_multiple_highlight"
require_relative "support/with_model"

require "active_record"
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  # Define migrations (create_table, add_column, etc.)
  create_table :with_models do |t|
    t.string :title
    t.string :content
    # ... other columns
  end
end

# Set up DatabaseCleaner
require "database_cleaner"
DatabaseCleaner.strategy = :transaction
