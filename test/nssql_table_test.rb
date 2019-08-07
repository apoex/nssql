# frozen_string_literal: true

require 'test_helper'

class NssqlTableTest < Minitest::Test
  class TestTable
    include NSSQL::Table

    ns_table_name   :test_table
    ns_primary_keys :id, :line_id
    ns_column       :id
    ns_column       :name, as: :display_name
    ns_column       :line_id
  end

  def test_table_name
    assert_equal :test_table, TestTable.ns_table_name
  end

  def test_primary_keys
    assert_equal %i[id line_id], TestTable.ns_primary_keys
  end

  def test_columns
    expected_columns = { id: {}, line_id: {}, name: { as: :display_name } }
    assert_equal expected_columns, TestTable.ns_columns
  end

  def test_aliased_column_names
    assert_equal %i[id line_id display_name], TestTable.ns_aliased_column_names
  end

  def test_column_names
    assert_equal %i[id line_id name], TestTable.ns_column_names
  end

  def test_select_ns_columns_query_without_where
    query = TestTable.select_ns_columns_query

    expected_query = <<~SQL
      SELECT
        id,line_id,name
      FROM
        test_table

      ORDER BY
        id
    SQL

    assert_equal expected_query, query
  end

  def test_select_ns_columns_query_with_where
    query = TestTable.select_ns_columns_query(where: 'id > 500')

    expected_query = <<~SQL
      SELECT
        id,line_id,name
      FROM
        test_table
      WHERE id > 500
      ORDER BY
        id
    SQL

    assert_equal expected_query, query
  end
end
