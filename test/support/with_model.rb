# frozen_string_literal: true

require "pg_search"
require "pg_search_multiple_highlight"

class WithModel < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search,
                  against: { title: "A", content: "B" },
                  using: {
                    tsearch: {
                      multiple_highlight: {
                        StartSel: "<b>",
                        StopSel: "</b>",
                        MaxWords: 400,
                        MinWords: 200,
                        ShortWord: 4,
                        HighlightAll: true,
                        MaxFragments: 3,
                        FragmentDelimiter: "&hellip;"
                      },
                      normalization: 2,
                      dictionary: "english",
                      any_word: true,
                      tsvector_column: "searchable"
                    }
                  }
end
