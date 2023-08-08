# frozen_string_literal: true

module PgSearch
  # nodoc
  module Features
    # Extends class to enable multiple_ighlight method for the search results
    class TSearch < Feature
      def self.valid_options
        super + %i[multiple_highlight]
      end

      def multiple_highlight
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

    def against_columns
      config = @normalizer.instance_variable_get(:@config)

      config.instance_variable_get(:@options)[:against].keys
    end

    def dictionary
      @options[:dictionary] || "simple"
    end

    def scope_options
      raw_options = @options[:multiple_highlight]

      raw_options.map { |key, value| "#{key}=#{value}" }.join(", ")
    end
  end
end
