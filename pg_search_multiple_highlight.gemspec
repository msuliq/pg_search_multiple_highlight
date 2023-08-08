# frozen_string_literal: true

require_relative "lib/pg_search_multiple_highlight/version"

Gem::Specification.new do |spec|
  spec.name = "pg_search_multiple_highlight"
  spec.version = PgSearchMultipleHighlight::VERSION
  spec.authors = ["Suleyman Musayev"]
  spec.email = ["slmusayev@gmail.com"]

  spec.summary = "Gem that enables highlighting search results when searching
   against multiple attributes with pg_search"
  spec.description = "This gem provides a workaround for the known issue of highlighting
   results when searching against multiple attributes with pg_search"
  spec.homepage = "https://github.com/msuliq/pg_search_multiple_highlight"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/msuliq/pg_search_multiple_highlight"
  spec.metadata["changelog_uri"] = "https://github.com/msuliq/pg_search_multiple_highlight/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "pg_search", "~> 2.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
