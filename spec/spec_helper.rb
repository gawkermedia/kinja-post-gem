RSpec.configure do |c|
  # filter_run is short-form alias for filter_run_including
  # c.filter_run :focus => true
end

require 'dotenv'
ENV = Dotenv.load unless ENV

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.allow_http_connections_when_no_cassette = true
end

require_relative '../lib/kinja'
