require 'httparty'

module Pandadoc
  module Api
    class Client
      def get(path, token, params = {})
        uri = build_uri(path)
        HTTParty.get(uri, headers: default_headers(token), query: params)
      end

      def post_json(path, token, params = {})
        uri = build_uri(path)
        headers = default_headers(token).merge('Content-Type' => 'application/json')

        HTTParty.post(uri, headers: headers, body: params.to_json)
      end

      private

      def default_headers(token)
        {
          'Authorization' => "Bearer #{token}"
        }
      end

      def build_uri(path)
        File.join(Pandadoc::Api::API_ROOT, path)
      end
    end
  end
end
