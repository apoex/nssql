# frozen_string_literal: true

require 'test_helper'

class NssqlSettingsTest < Minitest::Test
  def test_that_it_is_configurable
    NSSQL::Settings.configure do |config|
      config.user     = 'test-user'
      config.password = 'test-password'
    end

    assert_equal 'test-user', NSSQL::Settings.user
    assert_equal 'test-password', NSSQL::Settings.password

    NSSQL::Settings.configure do |config|
      config.user     = nil
      config.password = nil
    end
  end

  def test_that_it_is_configurable_with_env
    ENV["NETSUITE_USER"] = 'test-env-user'
    ENV["NETSUITE_PASSWORD"] = 'test-env-password'

    assert_equal 'test-env-user', NSSQL::Settings.user
    assert_equal 'test-env-password', NSSQL::Settings.password

    ENV["NETSUITE_USER"] = nil
    ENV["NETSUITE_PASSWORD"] = nil
  end
end
