require "test_helper"

class NssqlTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::NSSQL::VERSION
  end
end
