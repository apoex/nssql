# frozen_string_literal: true

require 'test_helper'

class NssqlSettingsTest < Minitest::Test
  def test_that_it_is_configurable
    NSSQL::Settings.configure do |config|
      config.odbc_user           = 'TEST_ODBC_USER'
      config.odbc_client_id      = 'TEST_ODBC_CLIENT_ID'
      config.odbc_certificate_id = 'TEST_ODBC_CERTIFICATE_ID'
      config.odbc_private_key    = 'TEST_ODBC_PRIVATE_KEY'
      config.odbc_account        = 'TEST_ODBC_ACCOUNT'
    end

    assert_equal 'TEST_ODBC_USER', NSSQL::Settings.odbc_user
    assert_equal 'TEST_ODBC_CLIENT_ID', NSSQL::Settings.odbc_client_id
    assert_equal 'TEST_ODBC_CERTIFICATE_ID', NSSQL::Settings.odbc_certificate_id
    assert_equal 'TEST_ODBC_PRIVATE_KEY', NSSQL::Settings.odbc_private_key
    assert_equal 'TEST_ODBC_ACCOUNT', NSSQL::Settings.odbc_account

    NSSQL::Settings.configure do |config|
      config.odbc_user           = nil
      config.odbc_client_id      = nil
      config.odbc_certificate_id = nil
      config.odbc_private_key    = nil
      config.odbc_account        = nil
    end
  end
end
