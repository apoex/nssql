# frozen_string_literal: true

require 'nssql/settings'

# Dynamically generate the connection properties for the NetSuite ODBC driver.
# The NetSuite2.com datasource uses short-lived OAuth2 tokens for authentication.
# The token is fetched from the NetSuite OAuth2 token endpoint using a JWT assertion.
module NSSQL
  class OdbcAuthentication
    def self.drvconnect_string
      new.drvconnect_string
    end

    def self.drvconnect_hash
      new.drvconnect_hash
    end

    def initialize
    end

    def drvconnect_string
      <<~DRVCONNECT.gsub("\n", "").strip
        DRIVER=/opt/netsuite/odbcclient/lib64/ivoa27.so;
        HOST=#{connect_host};
        PORT=1708;
        ServerDataSource=NetSuite2.com;
        Encrypted=1;
        AllowSinglePacketLogout=1;
        Truststore=/opt/netsuite/odbcclient/cert/ca3.cer;
        UID=#{user};
        CustomProperties=AccountID=#{account_id};RoleID=3;OAuth2Token=#{access_token};
      DRVCONNECT
    end

    def drvconnect_hash
      {
        "DRIVER" => "/opt/netsuite/odbcclient/lib64/ivoa27.so",
        "HOST"   => connect_host,
        "PORT"   => "1708",
        "ServerDataSource" => "NetSuite2.com",
        "Encrypted" => "1",
        "AllowSinglePacketLogout" => "1",
        "Truststore" => "/opt/netsuite/odbcclient/cert/ca3.cer",
        "UID" => user,
        "CustomProperties" => "AccountID=#{account_id};RoleID=3;OAuth2Token=#{access_token}"
      }
    end

    def access_token
      now = Time.now
      payload = {
        "iss": client_id,
        "scope": scopes,
        "aud": connect_endpoint_url,
        "iat": now.to_i,
        "exp": now.to_i + 3600,
      }

      jwt_assertion = JWT.encode(payload, private_key, "ES512", { kid: certificate_id })

      data = {
        "grant_type": grant_type,
        "client_assertion_type": client_assertion_type,
        "client_assertion": jwt_assertion,
      }

      conn.post(token_endpoint_url, data).body["access_token"]
    end

    private

    def conn
      @conn ||= Faraday.new do |f|
        f.request :url_encoded
        f.response :json
      end
    end

    def grant_type
      "client_credentials"
    end

    def client_assertion_type
      "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    end

    def scopes
      ["SuiteAnalytics"]
    end

    def token_endpoint_url
      "https://#{account_subdomain}.suitetalk.api.netsuite.com/services/rest/auth/oauth2/v1/token"
    end

    def connect_endpoint_url
      "https://#{account_subdomain}.connect.api.netsuite.com/services/rest/auth/oauth2/v1/token"
    end

    def connect_host
      "#{account_subdomain}.connect.api.netsuite.com"
    end

    def account
      NSSQL::Settings.odbc_account
    end

    def account_id
      account.gsub("-", "_")
    end

    def account_subdomain
      account.gsub("_", "-")
    end

    def user
      NSSQL::Settings.odbc_user
    end

    def client_id
      NSSQL::Settings.odbc_client_id
    end

    def certificate_id
      NSSQL::Settings.odbc_certificate_id
    end

    def private_key
      OpenSSL::PKey::EC.new(NSSQL::Settings.odbc_private_key)
    end
  end
end
