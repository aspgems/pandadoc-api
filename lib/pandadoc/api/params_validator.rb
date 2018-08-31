module Pandadoc
  module Api
    class ParamsValidator
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

      def self.validate(params, validations)
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
    end
  end
end
