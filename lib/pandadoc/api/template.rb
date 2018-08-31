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

      def validated_params(params, validations)
        valid_keys = validations.keys
        valid_params = params.keep_if { |key| valid_keys.include? key }

        validations.each_pair do |key, validators|
          if validators[:required] == true && valid_params[key].nil?
            raise RequiredParameterError.new('Missing required parameter', key)
          end

          validators_type_array = validators[:type].is_a?(Array) ? validators[:type] : [validators[:type]]
          if valid_params[key] && !validators_type_array.include?(valid_params[key].class)
            raise ParameterTypeError.new("Invalid parameter type, received #{valid_params[key].class} requested #{validators[:type]}", valid_params[:key].class, validators[:type])
          end
        end

        valid_params
      end

      private

      def client
        @client ||= Pandadoc::Api::Client.new
      end
    end
  end
end
