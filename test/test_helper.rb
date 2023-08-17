# frozen_string_literal: true

require "bundler/setup"

require "warning"
# Ignore Ruby 2.7 warnings from Active Record
Warning.ignore :keyword_separation

# https://github.com/grodowski/undercover#setting-up-required-lcov-reporting
require "simplecov"
require "simplecov-lcov"
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start do
  add_filter(%r{^/spec/})
  enable_coverage(:branch)
end
require "undercover"

require "minitest/autorun"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pg_search_multiple_highlight"
require_relative "support/with_model"
require_relative "support/database"

DOCUMENTS_SCHEMA = lambda do |t|
  t.belongs_to :searchable, polymorphic: true, index: true
  t.text :title
  t.text :content
  t.timestamps null: false

  # Used to test additional_attributes setup
  t.text :additional_attribute_column
end

# Set up DatabaseCleaner
require "database_cleaner"
DatabaseCleaner.strategy = :transaction
