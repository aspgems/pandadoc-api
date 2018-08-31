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

    it 'passes validated params' do
      params = { q: 'recipe' }
      validated_params = stub_params_validator(params)

      subject.list(token, params)

      expect(client_spy).to have_received(:get).with('/templates', token, validated_params)
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

  def stub_params_validator(params)
    double(:validated_params).tap do |validated_params|
      allow(Pandadoc::Api::ParamsValidator).to receive(:validate).with(params, any_args).and_return(validated_params)
    end
  end
end
