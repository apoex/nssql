# frozen_string_literal: true

module NSSQL
  # Base class for representing NetSuite tables.
  # Table name, primary keys and wanted columns are expected to be defined.
  module Table
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def select_ns_columns_query(where: nil)
        where_statement = "WHERE #{where}" if where

        <<~SQL
          SELECT
            #{ns_columns.join(',')}
          FROM
            #{ns_table_name}
          #{where_statement if where}
          ORDER BY
            #{ns_primary_keys.first}
        SQL
      end

      def ns_table_name(ns_table_name = nil)
        return @ns_table_name if ns_table_name.nil?

        @ns_table_name = ns_table_name
      end

      def ns_primary_keys(*ns_primary_keys)
        return @ns_primary_keys if ns_primary_keys.empty?

        @ns_primary_keys = ns_primary_keys
      end

      def ns_columns(*ns_columns)
        return @ns_columns if ns_columns.empty?

        @ns_columns = ns_columns
      end
    end
  end
end
