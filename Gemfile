# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem"s dependencies in pg_search_multiple_highlight.gemspec
gemspec

if ENV["ACTIVE_RECORD_BRANCH"]
  gem "activerecord", git: "https://github.com/rails/rails.git", branch: ENV.fetch("ACTIVE_RECORD_BRANCH", nil)
  gem "arel", git: "https://github.com/rails/arel.git" if ENV.fetch("ACTIVE_RECORD_BRANCH", nil) == "master"
end

gem "activerecord-jdbcpostgresql-adapter", ">= 1.3.1", platform: :jruby
gem "bundle-audit", "~> 0.1.0"
gem "pg", ">= 0.21.0", platform: :ruby
gem "rake", "~> 13.0"
gem "rubocop", "~> 1.21"
gem "rubocop-minitest"
gem "rubocop-performance"
gem "rubocop-rails"
gem "rubocop-rake"

group :development, :test do
  gem "byebug"
  gem "database_cleaner"
  gem "minitest", "~> 5.0"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "single_cov", "~> 1.9"
  gem "standard", ">= 1.23.0"
  gem "undercover"
  gem "warning"
  gem "with_model"
end
