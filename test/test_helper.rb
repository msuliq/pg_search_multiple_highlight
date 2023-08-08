# frozen_string_literal: true

require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "minitest/autorun"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pg_search_multiple_highlight"
