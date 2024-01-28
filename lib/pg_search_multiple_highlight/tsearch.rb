# frozen_string_literal: true

module PgSearch
  # nodoc
  module Features
    # Extends class to enable multiple_ighlight method for the search results
    class TSearch < Feature
      def self.valid_options
        super + %i[dictionary prefix negation any_word normalization tsvector_column highlight multiple_highlight]
      end

      def multiple_highlight
        config = @normalizer.instance_variable_get(:@config)

        against_columns = config.instance_variable_get(:@options)[:against].keys

        @model.search(query).map do |result|
          highlighted_fields = {
            id: result.id
          }
          against_columns.each do |column|
            highlighted_fields[column] = highlight_multiple_fields(result.send(column), query)
          end

          highlighted_fields
        end
      end

      def highlight_multiple_fields(text, query)
        split_words = query.split(/\s+/).map { |word| Regexp.escape(word) }

        regex = Regexp.new("\\b(#{split_words.join("|")})\\b", Regexp::IGNORECASE)

        text.gsub(regex) { |match| "<mark>#{match}</mark>" }
      end
    end
  end
end
