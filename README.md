# PgSearchMultipleHighlight

The `pg_search_multiple_highlight` gem extends the functionality of the popular `pg_search`
gem to overcome its limitation when performing searches against multiple columns and
attempting to highlight results. The core issue arises when using the `:highlight` option
within the `:tsearch` scope on multiple columns.

This gem addresses this limitation by introducing the `:multiple_highlight` option,
offering a comprehensive solution for highlighting results across multiple columns.

## Installation
To install the gem run the following command in the terminal:

    $ bundle add pg_search_multiple_highlight

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pg_search_multiple_highlight

## Usage

To extend functionality of the `pg_search` gem, require the gemfile in the same file, where
a PgSearch module is included:
```ruby
require 'pg_search_multiple_highlight'

class Shape < ActiveRecord::Base
  include PgSearch::Model
end
```

Usage of the `:multiple_highlight` is similar to the standard `:highlight`.

Adding `.with_pg_search_multiple_highlight` after the `pg_search_scope` you can access
`pg_multiple_highlight` attribute for each object.


```ruby
require 'pg_search_multiple_highlight'

class Article < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search,
                  against: { title: 'A', description: 'B' },
                  using: {
                    tsearch: {
                      multiple_highlight: {
                        StartSel: '<b>',
                        StopSel: '</b>',
                        MaxWords: 400,
                        MinWords: 200,
                        ShortWord: 4,
                        HighlightAll: true,
                        MaxFragments: 3,
                        FragmentDelimiter: '&hellip;'
                      }
                    }
                  }
end

Article.create!(:title => "Quick brown fox", :description => "The quick brown fox jumps over the lazy dog.")

first_match = Article.search("brown").with_pg_search_multiple_highlight.first
first_match.pg_search_multiple_highlight
# => {:id=>1,
#     :title=>"Quick <b>brown</b> fox",
#     :description=>"The quick <b>brown</b> fox jumps over the lazy dog."}
```

## Contributing

Bug reports and pull requests are welcome at https://github.com/msuliq/pg_search_multiple_highlight.

The best way to contribute would be to fork this repo, create a new branch from main, to merge the branch into main of the fork once the new code is in place and then open a pull request to merge forked main into the main of the present repo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PgSearchMultipleHighlight project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/msuliq/pg_search_multiple_highlight/blob/main/CODE_OF_CONDUCT.md).
