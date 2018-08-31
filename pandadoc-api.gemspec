lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pandadoc/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'pandadoc-api'
  spec.version       = Pandadoc::Api::VERSION
  spec.authors       = ['Michael Carey', 'Damian Galarza']
  spec.email         = ['mike@catchandrelease.com']

  spec.summary       = 'Ruby API Wrapper for the PandaDoc API'
  spec.description   = 'Ruby API Wrapper for the PandaDoc API'
  spec.homepage      = 'http://github.com/CatchRelease/pandadoc-api'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.16'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'webmock', '~> 3.4'
  spec.add_development_dependency 'pry'
end
