# frozen_string_literal: true

require 'singleton'

module NSSQL
  # Simple class for configuration of credentials.
  class Settings
    include Singleton

    SETTINGS = %i[
      odbc_user
      odbc_client_id
      odbc_certificate_id
      odbc_private_key
      odbc_account
    ].freeze

    attr_accessor(*SETTINGS)

    class << self
      SETTINGS.each do |setting|
        define_method(setting) do
          instance.public_send(setting) || ENV["NETSUITE_#{setting.upcase}"]
        end
      end

      def configure
        yield instance
      end
    end
  end
end
