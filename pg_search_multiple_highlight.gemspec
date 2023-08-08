# frozen_string_literal: true

require_relative "lib/pg_search_multiple_highlight/version"

Gem::Specification.new do |spec|
  spec.name = "pg_search_multiple_highlight"
  spec.version = PgSearchMultipleHighlight::VERSION
  spec.authors = ["Suleyman Musayev"]
  spec.email = ["slmusayev@gmail.com"]

  spec.summary = "The 'pg_search_multiple_highlight' gem enhances the 'pg_search' gem by
   introducing a new scope option, ':multiple_highlight', which enables highlighting of
   search results across multiple columns, addressing the limitation of 'pg_search' in
   handling multiple column searches."
  spec.description = "The 'pg_search_multiple_highlight' gem extends the functionality of
   the popular 'pg_search' gem to overcome its limitation when performing searches against
   multiple columns and attempting to highlight results. The core issue arises when using
   the ':highlight' option within the ':tsearch' scope on multiple columns. This gem
   addresses this limitation by introducing the ':multiple_highlight' option, offering a
   comprehensive solution for highlighting results across multiple columns.

   Key Features:
   New Scope Option: The gem introduces the ':multiple_highlight' scope option, allowing
    users to perform searches on multiple columns and highlight matching terms.
   Enhanced Search Results: The gem enables the extraction of highlighted results from
    multiple columns, providing a unified view of highlighted content.
   Usage Convenience: Users can easily integrate the ':multiple_highlight' option into
    their existing 'pg_search' queries by calling the '.with_pg_search_multiple_highlight'
    method on the search object.
   Flexible Customization: The gem's options can be tailored to match specific
    highlighting requirements, such as custom start and stop markers for highlighting.
   Comprehensive Documentation: The README file explains the limitations of 'pg_search'
    regarding highlighting, demonstrates how the ':multiple_highlight' option resolves
    this issue, and offers clear usage examples for quick integration."
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
