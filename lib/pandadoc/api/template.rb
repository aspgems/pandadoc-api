module Pandadoc
  module Api
    class Template
      def list(token, params = {})
        validations = {
          q: { required: false, type: String },
          tag: { required: false, type: String },
          count: { required: false, type: Integer },
          page: { required: false, type: Integer }
        }

        client.get '/templates', token, validated_params(params, validations)
      end

      def details(token, template_id)
        client.get "/templates/#{template_id}/details", token
      end

      private

      def validated_params(params, validations)
        Pandadoc::Api::ParamsValidator.validate(params, validations)
      end

      def client
        @client ||= Pandadoc::Api::Client.new
      end
    end
  end
end
