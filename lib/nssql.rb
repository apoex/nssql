# frozen_string_literal: true

require 'nssql/version'
require 'nssql/settings'
require 'nssql/table'
require 'nssql/odbc_authentication'

require 'odbc_utf8'
require 'tempfile'

# NSSQL module.
#
module NSSQL
  class Error < StandardError; end

  class << self
    def select_array(query)
      execute(query, &:fetch_all)
    end

    def select_to_file(query)
      query = one_line_query(query)

      isql_command = "isql -k \"#{NSSQL::OdbcAuthentication.drvconnect_string}\" -v -b -q -d,"
      iconv_command = 'iconv -f iso-8859-1 -t utf-8'

      Tempfile.new.tap do |file|
        system_call("echo \"#{query}\" | #{isql_command} | #{iconv_command} > #{file.path}")
      end
    end

    def configure
      NSSQL::Settings.configure
    end

    private

    def execute(query)
      statement = netsuite_connection.prepare(query).execute
      result = yield statement

      statement.drop

      result
    end

    def system_call(command)
      `#{command}`
    end

    def one_line_query(query)
      query.tr("\n", ' ').gsub(/\s+/, ' ').strip
    end

    def netsuite_connection
      driver = ODBC::Driver.new
      driver.name = 'NetSuite'
      driver.attrs = NSSQL::OdbcAuthentication.drvconnect_hash
      ODBC::Database.new.drvconnect(driver)
    end
  end
end
