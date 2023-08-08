# frozen_string_literal: true

module PgSearch
  # Extends standard scope options for pg_search so :multiple_highlight can be used
  # the same way as other search options
  class ScopeOptions
    def apply(scope)
      scope = include_table_aliasing_for_rank(scope)
      rank_table_alias = scope.pg_search_rank_table_alias(include_counter: true)

      scope
        .joins(rank_join(rank_table_alias))
        .order(Arel.sql("#{rank_table_alias}.rank DESC, #{order_within_rank}"))
        .extend(WithPgSearchRank)
        .extend(WithPgSearchHighlight[feature_for(:tsearch)])
        .extend(WithPgSearchMultipleHighlight[feature_for(:tsearch)])
    end

    # This a workaround https://github.com/Casecommons/pg_search/issues/336 issue of the pg_search gem that does not
    # support highlighting results when a tsearch is performed against more than one column
    module WithPgSearchMultipleHighlight
      def self.[](tsearch)
        Module.new do
          include WithPgSearchMultipleHighlight
          define_method(:tsearch) { tsearch }
        end
      end

      def tsearch
        raise TypeError, "You need to instantiate this module with []"
      end

      def with_pg_search_multiple_highlight
        scope = self
        scope.select("#{table_name}.*") unless scope.select_values.any?

        tsearch.multiple_highlight
      end
    end
  end
end
