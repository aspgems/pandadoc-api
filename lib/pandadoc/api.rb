require 'pandadoc/api/client'
require 'pandadoc/api/params_validator'
require 'pandadoc/api/version'
require 'pandadoc/api/document'
require 'pandadoc/api/template'

module Pandadoc
  module Api
    API_VERSION = 'v1'.freeze
    API_ROOT = "https://api.pandadoc.com/public/#{API_VERSION}".freeze
  end
end
