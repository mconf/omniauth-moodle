require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class MoodleURLNotInformed < StandardError
      def initialize(message=nil)
        message ||= 'The URL for you Moodle website was not configured or is invalid. Inform it together with the client_id and client_token when defining this Oauth2 provider.'
        super
      end
    end

    class Moodle < OmniAuth::Strategies::OAuth2

      option :name, :moodle
      option :site, nil

      option :client_options, {
        :authorize_url => "/local/oauth/login.php",
        :token_url     => "/local/oauth/token.php",
        :info_url      => "/local/oauth/user_info.php"
      }

      uid { raw_info["username"] }

      info { raw_info }

      # To include a configurable URL via parameters
      def client
        begin
          uri = URI.parse(options.site)

          options.client_options.merge!({
            :site => "#{uri.scheme}://#{uri.host}",
            :authorize_url => "#{uri.path}#{options[:client_options][:authorize_url]}",
            :token_url => "#{uri.path}#{options[:client_options][:token_url]}",
            :info_url => "#{uri.path}#{options[:client_options][:info_url]}"
          })

        rescue URI::InvalidURIError
          fail(MoodleURLNotInformed)
        end

        super
      end

      def raw_info
        @raw_info ||= access_token.post(options.client_options.info_url, :parse => :json).parsed
      end
    end
  end
end
