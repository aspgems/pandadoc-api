describe Pandadoc::Api do
  it 'has a version number' do
    expect(Pandadoc::Api::VERSION).not_to be nil
  end

  it 'defines an API_ROOT' do
    expect(Pandadoc::Api::API_ROOT).not_to be nil
  end
end
