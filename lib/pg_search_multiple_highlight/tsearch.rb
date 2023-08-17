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
        tsquery = ActiveRecord::Base.connection.quote(query)

        dictionary = @options[:dictionary] || "simple"

        raw_options = @options[:multiple_highlight]

        scope_options = raw_options.map { |key, value| "#{key}=#{value}" }.join(", ")

        sanitized_sql = ActiveRecord::Base.send(
          :sanitize_sql_array, [
            "SELECT ts_headline(
              ?, to_tsquery('#{dictionary}', ?),
              '#{scope_options}'
              ) AS highlighted_text",
            text, tsquery
          ]
        )
        ActiveRecord::Base.connection.execute(sanitized_sql).first["highlighted_text"]
      end
    end
  end
end
