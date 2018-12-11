require 'spec_helper'

describe Pandadoc::Api::Document do
  subject { Pandadoc::Api::Document.new }

  let(:token) { 'token' }
  let(:response) { double(:response) }
  let(:client_spy) { spy(Pandadoc::Api::Client, get: response, post_json: response) }

  before do
    allow(Pandadoc::Api::Client).to receive(:new).and_return(client_spy)
  end

  describe 'list' do
    it 'calls the right endpoint' do
      subject.list(token, {})

      expect(client_spy).to have_received(:get).with('/documents', token, {})
    end

    it 'passes the validated params' do
      params = { q: 'recipe' }
      validated_params = stub_params_validator(params)

      subject.list(token, params)

      expect(client_spy).to have_received(:get).with('/documents', token, validated_params)
    end

    it 'returns results' do
      params = { q: 'recipe' }

      expect(subject.list(token, params)).to eq response
    end
  end

  describe 'create' do
    it 'calls the right endpoint' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }

      subject.create(token, params)

      expect(client_spy).to have_received(:post_json).with('/documents', token, params)
    end

    it 'passes validated params' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }
      validated_params = stub_params_validator(params)

      subject.create(token, params)

      expect(client_spy).to have_received(:post_json).with('/documents', token, validated_params)
    end

    it 'returns results' do
      params = { name: 'My Doc', template_uuid: '1234', recipients: ['a@a.com'] }

      expect(subject.create(token, params)).to eq response
    end
  end

  describe 'status' do
    it 'calls the right endpoint' do
      document_id = 22
      subject.status(token, document_id)

      expect(client_spy).to have_received(:get).with('/documents/22', token)
    end

    it 'returns results' do
      expect(subject.status(token, 55)).to eq response
    end
  end

  describe 'details' do
    it 'calls the right endpoint' do
      document_id = 22
      subject.details(token, document_id)

      expect(client_spy).to have_received(:get).with('/documents/22/details', token)
    end

    it 'returns results' do
      expect(subject.details(token, 55)).to eq response
    end
  end

  describe 'send_doc' do
    it 'calls the right endpoint' do
      document_id = 55
      subject.send_doc(token, document_id)

      expect(client_spy).to have_received(:post_json).with("/documents/#{document_id}/send", token, {})
    end

    it 'passes validated params' do
      document_id = 66
      params = { message: 'Take a look', silent: true }
      validated_params = stub_params_validator(params)

      subject.send_doc(token, document_id, params)

      expect(client_spy).to have_received(:post_json).with("/documents/#{document_id}/send", token, validated_params)
    end

    it 'returns results' do
      document_id = 88

      expect(subject.send_doc(token, document_id)).to eq response
    end
  end

  describe 'link' do
    let(:session_id) { 'QYCPtavst3DqqBK72ZRtbF' }
    let(:response) { double(:response, body: { id: session_id }.to_json) }

    it 'calls the right endpoint' do
      document_id = 99

      subject.link(token, document_id, recipient: 'musk@tesla.com')

      expect(client_spy).to have_received(:post_json).with("/documents/#{document_id}/session", token, recipient: 'musk@tesla.com')
    end

    it 'passes validated params' do
      params = { recipient: 'musk@tesla.com' }
      document_id = 99
      validated_params = stub_params_validator(params)

      subject.link(token, document_id, recipient: 'musk@tesla.com')

      expect(client_spy).to have_received(:post_json).with("/documents/#{document_id}/session", token, validated_params)
    end

    it 'returns results' do
      document_id = 333
      params = { recipient: 'chevy@chevy.com' }

      expect(subject.link(token, document_id, params)).to eq("https://app.pandadoc.com/s/#{session_id}")
    end
  end

  describe 'download' do
    it 'calls the right endpoint' do
      document_id = 444

      subject.download(token, document_id)

      expect(client_spy).to have_received(:get).with("/documents/#{document_id}/download", token)
    end

    it 'returns the file' do
      expect(subject.download(token, 55)).to eq response
    end
  end

  describe 'delete' do
    it 'calls the right endpoint' do
      document_id = 22
      subject.delete(token, document_id)

      expect(client_spy).to have_received(:delete).with('/documents/22', token)
    end
  end

  def stub_params_validator(params)
    double(:validated_params).tap do |validated_params|
      allow(Pandadoc::Api::ParamsValidator).to receive(:validate).with(params, any_args).and_return(validated_params)
    end
  end
end
