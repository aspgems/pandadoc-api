require 'spec_helper'

describe Pandadoc::Api::ParamsValidator do
  describe '.validate' do
    describe 'basic behavior' do
      it 'returns {}' do
        expect(described_class.validate({}, {})).not_to be_nil
      end
    end

    describe 'passes validations' do
      describe 'invalid parameter' do
        it 'returns only the valid params' do
          params = { valid: '1', invalid: '2' }
          validations = { valid: { required: false, type: String } }

          expect(described_class.validate(params, validations)).to eq(valid: '1')
        end
      end
    end

    describe 'missing required' do
      it 'raises a RequiredParameterError' do
        params = { can_exist: '2' }
        validations = { has_to_exist: { required: true, type: String }, can_exist: { required: false, type: String } }

        expect do
          described_class.validate(params, validations)
        end.to raise_error(described_class::RequiredParameterError)
      end
    end

    describe 'invalid type' do
      it 'raises a ParameterTypeError' do
        params = { string_type: 2 }
        validations = { string_type: { required: false, type: String } }

        expect do
          described_class.validate(params, validations)
        end.to raise_error(described_class::ParameterTypeError)
      end
    end
  end
end
