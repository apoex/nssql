# frozen_string_literal: true

module NSSQL
  # Simple class for configuration of credentials.
  class Settings
    include Singleton

    SETTINGS = %i[
      user
      password
    ].freeze

    attr_accessor(*SETTINGS)

    class << self
      SETTINGS.each do |setting|
        define_method(setting) do
          instance.public_send(setting)
        end
      end

      def configure
        yield instance
      end
    end
  end
end
