# frozen_string_literal: true

require 'nssql/version'
require 'nssql/settings'
require 'nssql/table'

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

      isql_command = "isql -v Netsuite #{NSSQL::Settings.user} '#{NSSQL::Settings.password}' -b -q -d,"
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
      netsuite_connection.prepare(query).execute.tap do |result|
        yield result if block_given?

        result.drop
      end
    end

    def system_call(command)
      `#{command}`
    end

    def one_line_query(query)
      query.tr("\n", ' ').gsub(/\s+/, ' ').strip
    end

    def netsuite_connection
      ODBC.connect('NetSuite', NSSQL::Settings.user, NSSQL::Settings.password)
    end
  end
end
