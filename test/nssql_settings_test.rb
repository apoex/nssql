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
  end
end
