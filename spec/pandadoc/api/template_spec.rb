require 'spec_helper'

describe Pandadoc::Api::Template do
  subject { Pandadoc::Api::Template.new }
  let(:token) { 'token' }
  let(:response) { double(:response) }
  let(:client_spy) { spy(Pandadoc::Api::Client, get: response) }

  before do
    allow(Pandadoc::Api::Client).to receive(:new).and_return(client_spy)
  end

  describe 'list' do
    it 'calls the right endpoint' do
      subject.list(token, {})

      expect(client_spy).to have_received(:get).with('/templates', token, {})
    end

    it 'passes the params' do
      params = { q: 'recipe' }

      subject.list(token, params)

      expect(client_spy).to have_received(:get).with('/templates', token, params)
    end

    it 'returns results' do
      expect(subject.list(token)).to eq response
    end
  end

  describe 'details' do
    it 'calls the right endpoint' do
      template_id = 22

      subject.details(token, template_id)

      expect(client_spy).to have_received(:get).with("/templates/#{template_id}/details", token)
    end

    it 'returns results' do
      expect(subject.details(token, 55)).to eq response
    end
  end

  describe 'validated_params' do
    describe 'basic behavior' do
      it 'returns {}' do
        expect(subject.validated_params({}, {})).not_to be_nil
      end
    end

    describe 'passes validations' do
      describe 'invalid parameter' do
        it 'returns only the valid params' do
          params = { valid: '1', invalid: '2' }
          validations = { valid: { required: false, type: String } }

          expect(subject.validated_params(params, validations)).to eq(valid: '1')
        end
      end
    end

    describe 'missing required' do
      it 'raises a RequiredParameterError' do
        params = { can_exist: '2' }
        validations = { has_to_exist: { required: true, type: String }, can_exist: { required: false, type: String } }

        expect do
          subject.validated_params(params, validations)
        end.to raise_error(RequiredParameterError)
      end
    end

    describe 'invalid type' do
      it 'raises a ParameterTypeError' do
        params = { string_type: 2 }
        validations = { string_type: { required: false, type: String } }

        expect do
          subject.validated_params(params, validations)
        end.to raise_error(ParameterTypeError)
      end
    end
  end
end
