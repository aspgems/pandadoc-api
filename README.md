# Pandadoc::Api  &nbsp;[![Build Status](https://secure.travis-ci.org/CatchRelease/pandadoc-api.svg?branch=master)](https://travis-ci.org/CatchRelease/pandadoc-api) [![Gem Version](https://img.shields.io/gem/v/pandadoc-api.svg)](https://rubygems.org/gems/pandadoc-api)

PandaDoc API is meant to be a simplistic ruby wrapper around the PandaDoc API. It assumes that token management is handled 
elsewhere and that parsing of the response is up to the user.

All options to the API Methods are available via the [PandaDoc API Documentation](https://developers.pandadoc.com/v1/reference).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pandadoc-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pandadoc-api

## Usage

#### Documents
Create a new instance
```ruby
document_api = Pandadoc::Api::Document.new
```

Call the API
```ruby
# List Documents
document_api.list(token, params = {}) # returns JSON

# Create Document from PandaDoc Template
document_api.create(token, params = {}) # returns JSON

# Document Status
document_api.status(token, document_id) # returns JSON

# Document Details
document_api.details(token, document_id) # returns JSON

# Send Document
document_api.send_doc(token, document_id, params = {}) # returns JSON

# Create a Document Link
document_api.link(token, document_id, params = {}) # returns String

# Download Document
document_api.download(token, document_id) # returns PDF File
```

#### Templates
Create a new instance
```ruby
template_api = Pandadoc::Api::Template.new
```

Call the API
```ruby
# List Templates
template_api.list(token, params = {}) # returns JSON

# Template Details
tempolate_api.details(token, template_id) # returns JSON
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CatchRelease/pandadoc-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pandadoc::Api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pandadoc-api/blob/master/CODE_OF_CONDUCT.md).
