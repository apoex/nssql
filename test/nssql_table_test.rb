require "test_helper"

class NssqlTableTest < Minitest::Test
  class TestTable < NSSQL::Table
    table_name   'test_table'
    primary_keys 'id', 'line_id'
    columns      'id', 'line_id', 'name'
  end

  def test_select_columns_query_without_where
    query = TestTable.select_columns_query

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

  def test_select_columns_query_with_where
    query = TestTable.select_columns_query(where: 'id > 500')

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
