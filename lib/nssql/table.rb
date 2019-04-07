# frozen_string_literal: true

module NSSQL
  # Base class for representing NetSuite tables.
  # Table name, primary keys and wanted columns are expected to be defined.
  class Table
    class << self
      def select_columns_query(where: nil)
        where_statement = "WHERE #{where}" if where

        <<~SQL
          SELECT
            #{@columns.join(',')}
          FROM
            #{@table_name}
          #{where_statement if where}
          ORDER BY
            #{@primary_keys.first}
        SQL
      end

      def table_name(table_name)
        @table_name = table_name
      end

      def primary_keys(*primary_keys)
        @primary_keys = primary_keys
      end

      def columns(*columns)
        @columns = columns
      end
    end
  end
end
