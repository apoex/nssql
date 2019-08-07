# frozen_string_literal: true

module NSSQL
  # Base class for representing NetSuite tables.
  # Table name, primary keys and wanted columns are expected to be defined.
  #
  module Table
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    # Class methods for NSSQL::Table module.
    #
    module ClassMethods
      attr_reader :ns_columns

      def select_ns_columns_query(where: nil)
        where_statement = "WHERE #{where}" if where

        <<~SQL
          SELECT
            #{ns_column_names.join(',')}
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

        @ns_primary_keys = ns_primary_keys.flatten
      end

      def ns_column(name, options = {})
        @ns_columns ||= {}
        @ns_columns[name] = options
      end

      def ns_aliased_column_names
        ns_columns.sort.map do |name, options|
          options[:as] || name
        end
      end

      def ns_column_names
        ns_columns.keys.sort
      end
    end
  end
end
