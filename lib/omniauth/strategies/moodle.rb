require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class MoodleURLNotInformed < StandardError
      def initialize(message=nil)
        message ||= 'The URL for you Moodle website was not configured. Inform it together with the client_id and client_token when defining this Oauth2 provider.'
        super
      end
    end

    class Moodle < OmniAuth::Strategies::OAuth2

      option :name, :moodle
      option :site, nil

      option :client_options, {
        :authorize_url => "/local/oauth/login.php",
        :token_url     => "/local/oauth/token.php"
      }

      uid { raw_info["username"] }

      info { raw_info }

      # To include a configurable URL via parameters
      def client
        fail(MoodleURLNotInformed) if options.site.blank?

        options.client_options.merge!({:site => options.site})
        super
      end

      def raw_info
        @raw_info ||= access_token.post("/local/oauth/user_info.php", :parse => :json).parsed
      end
    end
  end
end
