require 'spec_helper'

describe Pandadoc::Api::Client do
  subject { Pandadoc::Api::Client.new }
  let(:token) { 'token' }
  let(:path) { '/documents' }
  let(:uri) { "#{Pandadoc::Api::API_ROOT}#{path}" }

  before do
    stub_request(:any, /#{Pandadoc::Api::API_ROOT}/).with(headers: { 'Authorization' => "Bearer #{token}" })
  end

  after do
    WebMock.reset!
  end

  describe '#get' do
    before do
      stub_request(:any, /#{Pandadoc::Api::API_ROOT}/).with(headers: { 'Authorization' => "Bearer #{token}" })
    end

    it 'makes a GET request for the given path' do
      subject.get(path, token)

      expect(WebMock).to have_requested(:get, uri)
    end

    it 'passes params through with request' do
      params = { 'foo' => 'bar' }

      subject.get(path, token, params)

      expect(WebMock).to have_requested(:get, uri).with(query: params)
    end
  end

  describe '#post_json' do
    it 'makes a POST request to the given path' do
      subject.post_json(path, token)

      expect(WebMock).to have_requested(:post, uri).with(headers: { 'Content-Type': 'application/json' })
    end

    it 'sets the params as the body' do
      params = { 'foo' => 'bar' }

      subject.post_json(path, token, params)

      expect(WebMock).to have_requested(:post, uri).with(body: params.to_json)
    end
  end
end
