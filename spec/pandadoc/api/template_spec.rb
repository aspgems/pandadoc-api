require 'spec_helper'

describe Pandadoc::Api::Template do
  subject { Pandadoc::Api::Template.new }

  describe 'list' do
    before :each do
      stub_request(:get, "#{Pandadoc::Api::API_ROOT}/templates").with(query: hash_including({})).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      subject.list('token', {})

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/templates")).to have_been_made.once
    end

    it 'passes the params' do
      params = { q: 'recipe' }
      subject.list('token', params)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/templates").with(query: params)).to have_been_made
    end

    it 'sends authorization' do
      params = { q: 'recipe' }
      subject.list('token', params)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/templates").with(query: params, headers: {
                                                                            'Authorization': 'Bearer token'
                                                                          })).to have_been_made
    end

    it 'returns results' do
      params = { q: 'recipe' }
      expect(subject.list('token', params).code).to eq(200)
    end
  end

  describe 'details' do
    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/templates/{id}/details"
      stub_request(:get, uri_template).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      template_id = 22
      subject.details('token', template_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/templates/#{template_id}/details")).to have_been_made.once
    end

    it 'sends authorization' do
      template_id = 33
      subject.details('token', template_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/templates/#{template_id}/details").with(headers: {
                                                                                                   'Authorization': 'Bearer token'
                                                                                                 })).to have_been_made
    end

    it 'returns results' do
      expect(subject.details('token', 55).code).to eq(200)
    end
  end

  describe 'auth_header' do
    it 'returns the formatted auth header' do
      expect(subject.auth_header('mexican_food')).to eq('Bearer mexican_food')
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
