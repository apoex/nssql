# frozen_string_literal: true

require 'test_helper'

class NssqlTest < Minitest::Test
  def setup
    NSSQL::Settings.configure do |config|
      config.user     = 'USER'
      config.password = 'PASSWORD'
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::NSSQL::VERSION
  end

  def test_configure_delegation
    NSSQL::Settings.stub(:configure, 'test-delegation') do
      assert_equal 'test-delegation', NSSQL.configure
    end
  end

  def test_select_to_file_produces_correct_command
    expected_command = "echo \"SELECT 1+1\" | isql -v Netsuite USER 'PASSWORD' -b -q -d, | iconv -f iso-8859-1 -t utf-8"

    system_mock = lambda do |command|
      assert_equal expected_command, command.split(' > ').first

      @file_path = command.split(' > ').last
    end

    NSSQL.stub :system_call, system_mock do
      file = NSSQL.select_to_file('SELECT 1+1')

      assert_equal file.path, @file_path
    end
  end

  def test_select_to_file_one_line_query_squiggly
    query = <<~SQL
      SELECT
        a, b
      FROM
        table
    SQL

    flattened_query = 'echo "SELECT a, b FROM table"'

    system_mock = lambda do |command|
      assert_equal flattened_query, command.split(' | ').first
    end

    NSSQL.stub :system_call, system_mock do
      NSSQL.select_to_file(query)
    end
  end

  def test_select_to_file_one_line_query_non_squiggly
    query = <<-SQL
      SELECT
        a, b
      FROM
        table

      ORDER BY
        a
    SQL

    flattened_query = 'echo "SELECT a, b FROM table ORDER BY a"'

    system_mock = lambda do |command|
      assert_equal flattened_query, command.split(' | ').first
    end

    NSSQL.stub :system_call, system_mock do
      NSSQL.select_to_file(query)
    end
  end
end
