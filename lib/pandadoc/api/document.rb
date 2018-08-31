class RequiredParameterError < StandardError
  attr_reader :parameter

  def initialize(message, parameter)
    # Call the parent's constructor to set the message
    super(message)

    # Store the action in an instance variable
    @parameter = parameter
  end
end

class ParameterTypeError < StandardError
  attr_reader :received
  attr_reader :requested

  def initialize(message, received, requested)
    # Call the parent's constructor to set the message
    super(message)

    # Store the action in an instance variable
    @received = received
    @requested = requested
  end
end

module Pandadoc
  module Api
    class Document
      DOCUMENT_STATUS_MAP = {
        'document.draft': 0,
        'document.sent': 1,
        'document.completed': 2,
        'document.viewed': 5,
        'document.waiting_approval': 6,
        'document.approved': 7,
        'document.rejected': 8,
        'document.waiting_pay': 9,
        'document.paid': 10,
        'document.voided': 11
      }.freeze

      def list(token, params = {})
        validations = {
          q: { required: false, type: String },
          tag: { required: false, type: Integer },
          status: { required: false, type: Integer },
          count: { required: false, type: Integer },
          page: { required: false, type: Integer },
          metadata: { required: false, type: Hash }
        }

        client.get '/documents', token, validated_params(params, validations)
      end

      def create(token, params = {})
        validations = {
          name: { required: true, type: String },
          template_uuid: { required: true, type: String },
          recipients: { required: true, type: Array },
          tokens: { required: false, type: Hash },
          fields: { required: false, type: Hash },
          metadata: { required: false, type: Hash },
          pricing_tables: { required: false, type: Array }
        }

        client.post_json '/documents', token, validated_params(params, validations)
      end

      def status(token, document_id)
        client.get "/documents/#{document_id}", token
      end

      def details(token, document_id)
        client.get "/documents/#{document_id}/details", token
      end

      # send is already a Ruby thing, overriding it would be bad
      def send_doc(token, document_id, params = {})
        validations = {
          message: { required: false, type: String },
          silent: { required: false, type: [TrueClass, FalseClass] }
        }

        client.post_json "/documents/#{document_id}/send", token, validated_params(params, validations)
      end

      def link(token, document_id, params = {})
        validations = {
          recipient: { required: true, type: String },
          lifetime: { required: false, type: Integer }
        }

        response = client.post_json "/documents/#{document_id}/session", token, validated_params(params, validations)

        json_response = JSON.parse(response.body, symbolize_names: true)
        session_id = json_response[:id]

        "https://app.pandadoc.com/s/#{session_id}"
      end

      def download(token, document_id)
        client.get "/documents/#{document_id}/download", token
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
