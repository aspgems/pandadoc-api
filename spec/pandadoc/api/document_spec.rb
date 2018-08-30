require 'spec_helper'

describe Pandadoc::Api::Document do
  subject { Pandadoc::Api::Document.new }

  describe 'list' do
    before :each do
      stub_request(:get, "#{Pandadoc::Api::API_ROOT}/documents").with(query: hash_including({})).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      subject.list('token', {})

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents")).to have_been_made.once
    end

    it 'passes the params' do
      params = { q: 'recipe' }
      subject.list('token', params)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents").with(query: params)).to have_been_made
    end

    it 'sends authorization' do
      params = { q: 'recipe' }
      subject.list('token', params)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents").with(query: params, headers: {
                                                                            'Authorization': 'Bearer token'
                                                                          })).to have_been_made
    end

    it 'returns results' do
      params = { q: 'recipe' }
      expect(subject.list('token', params).code).to eq(200)
    end
  end

  describe 'create' do
    before :each do
      stub_request(:post, "#{Pandadoc::Api::API_ROOT}/documents").to_return(status: 201)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      subject.create('token', name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'])

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents")).to have_been_made.once
    end

    it 'passes the params as json' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }
      subject.create('token', params)

      expect(WebMock).to have_requested(:post, "#{Pandadoc::Api::API_ROOT}/documents").with(body: params.to_json)
    end

    it 'sends authorization' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }
      subject.create('token', params)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents").with(headers: {
                                                                             'Content-Type': 'application/json',
                                                                             'Authorization': 'Bearer token'
                                                                           })).to have_been_made
    end

    it 'returns results' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }
      expect(subject.create('token', params).code).to eq(201)
    end
  end

  describe 'status' do
    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/documents/{id}"
      stub_request(:get, uri_template).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      document_id = 22
      subject.status('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/22")).to have_been_made.once
    end

    it 'sends authorization' do
      document_id = 33
      subject.status('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}").with(headers: {
                                                                                           'Authorization': 'Bearer token'
                                                                                         })).to have_been_made
    end

    it 'returns results' do
      expect(subject.status('token', 55).code).to eq(200)
    end
  end

  describe 'details' do
    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/documents/{id}/details"
      stub_request(:get, uri_template).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      document_id = 22
      subject.details('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/22/details")).to have_been_made.once
    end

    it 'sends authorization' do
      document_id = 33
      subject.details('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/details").with(headers: {
                                                                                                   'Authorization': 'Bearer token'
                                                                                                 })).to have_been_made
    end

    it 'returns results' do
      expect(subject.details('token', 55).code).to eq(200)
    end
  end

  describe 'send_doc' do
    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/documents/{id}/send"
      stub_request(:post, uri_template).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      document_id = 55
      subject.send_doc('token', document_id)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/send")).to have_been_made.once
    end

    it 'passes the params' do
      document_id = 66
      params = { message: 'Take a look', silent: true }
      subject.send_doc('token', document_id, params)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/send").with do |req|
        req.body == 'message=Take%20a%20look&silent=true'
      end).to have_been_made
    end

    it 'sends authorization' do
      document_id = 77
      subject.send_doc('token', document_id)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/send").with(headers: {
                                                                                                 'Content-Type': 'application/json',
                                                                                                 'Authorization': 'Bearer token'
                                                                                               })).to have_been_made
    end

    it 'returns results' do
      document_id = 88
      expect(subject.send_doc('token', document_id).code).to eq(200)
    end
  end

  describe 'link' do
    let(:session_id) { 'QYCPtavst3DqqBK72ZRtbF' }

    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/documents/{id}/session"
      stub_request(:post, uri_template).to_return(status: 200, body: { id: session_id }.to_json)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      document_id = 99
      subject.link('token', document_id, recipient: 'musk@tesla.com')

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/session")).to have_been_made.once
    end

    it 'passes the params' do
      document_id = 111
      params = { recipient: 'henry@ford.com' }
      subject.link('token', document_id, params)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/session").with do |req|
        req.body == 'recipient=henry%40ford.com'
      end).to have_been_made
    end

    it 'sends authorization' do
      document_id = 222
      params = { recipient: 'chevy@chevy.com' }
      subject.link('token', document_id, params)

      expect(a_request(:post, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/session").with(headers: {
                                                                                                    'Authorization': 'Bearer token',
                                                                                                    'Content-Type': 'application/json'
                                                                                                  })).to have_been_made
    end

    it 'returns results' do
      document_id = 333
      params = { recipient: 'chevy@chevy.com' }
      expect(subject.link('token', document_id, params)).to eq("https://app.pandadoc.com/s/#{session_id}")
    end
  end

  describe 'download' do
    before :each do
      uri_template = Addressable::Template.new "#{Pandadoc::Api::API_ROOT}/documents/{id}/download"
      stub_request(:get, uri_template).to_return(status: 200)
    end

    after :each do
      WebMock.reset!
    end

    it 'calls the right endpoint' do
      document_id = 444
      subject.download('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/download")).to have_been_made.once
    end

    it 'sends authorization' do
      document_id = 555
      subject.download('token', document_id)

      expect(a_request(:get, "#{Pandadoc::Api::API_ROOT}/documents/#{document_id}/download").with(headers: {
                                                                                                    'Authorization': 'Bearer token'
                                                                                                  })).to have_been_made
    end

    it 'returns the file' do
      expect(subject.download('token', 55).code).to eq(200)
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
