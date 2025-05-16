# frozen_string_literal: true

require 'test_helper'

class NssqlTest < Minitest::Test
  def setup
    NSSQL::Settings.configure do |config|
      config.odbc_user           = 'TEST_ODBC_USER'
      config.odbc_client_id      = 'TEST_ODBC_CLIENT_ID'
      config.odbc_certificate_id = 'TEST_ODBC_CERTIFICATE_ID'
      config.odbc_private_key    = 'TEST_ODBC_PRIVATE_KEY'
      config.odbc_account        = 'TEST_ODBC_ACCOUNT'
    end
  end

  def teardown
    NSSQL::Settings.configure do |config|
      config.odbc_user           = nil
      config.odbc_client_id      = nil
      config.odbc_certificate_id = nil
      config.odbc_private_key    = nil
      config.odbc_account        = nil
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

  def test_select_array
    odbc_database_mock = mock('odbc_database_mock')
    odbc_connection_mock = mock('odbc_connection_mock')
    odbc_prepare_mock = mock('odbc_prepare_mock')
    odbc_execute_mock = mock('odbc_execute_mock')

    NSSQL::OdbcAuthentication.expects(:drvconnect_hash).returns({ 'key' => 'value' })
    ODBC::Database.expects(:new).returns(odbc_database_mock)
    odbc_database_mock.expects(:drvconnect).returns(odbc_connection_mock)
    odbc_connection_mock.expects(:prepare).with('SELECT 1+1').returns(odbc_prepare_mock)
    odbc_prepare_mock.expects(:execute).returns(odbc_execute_mock)
    odbc_execute_mock.expects(:fetch_all).returns([['2']])
    odbc_execute_mock.expects(:drop).returns(nil)

    assert_equal [['2']], NSSQL.select_array('SELECT 1+1')
  end

  def test_select_to_file_produces_correct_command
    expected_command = "echo \"SELECT 1+1\" | isql -k \"test_drvconnect_string\" -v -b -q -d, | iconv -f iso-8859-1 -t utf-8"

    NSSQL.expects(:system_call).with do |command|
      assert_equal expected_command, command.split(' > ').first
      @file_path = command.split(' > ').last
      true
    end
    NSSQL::OdbcAuthentication.expects(:drvconnect_string).returns('test_drvconnect_string')
    file = NSSQL.select_to_file('SELECT 1+1')

    assert_equal file.path, @file_path
  end

  def test_select_to_file_one_line_query_squiggly
    query = <<~SQL
      SELECT
        a, b
      FROM
        table
    SQL

    flattened_query = 'echo "SELECT a, b FROM table"'

    NSSQL.expects(:system_call).with do |command|
      assert_equal flattened_query, command.split(' | ').first
      true
    end
    NSSQL::OdbcAuthentication.expects(:drvconnect_string).returns('test_drvconnect_string')

    NSSQL.select_to_file(query)
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

    NSSQL.expects(:system_call).with do |command|
      assert_equal flattened_query, command.split(' | ').first
      true
    end
    NSSQL::OdbcAuthentication.expects(:drvconnect_string).returns('test_drvconnect_string')

    NSSQL.select_to_file(query)
  end

  def test_system_call
    assert_equal `ls`, NSSQL.send(:system_call, 'ls')
  end
end
