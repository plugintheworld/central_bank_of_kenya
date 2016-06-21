require 'vcr'

VCR.configure do |c|
  #the directory for your cassettes
  c.cassette_library_dir = 'spec/vcr'
  #your preferred http request service. Typhoeus and Fakeweb are other options
  c.hook_into :webmock
  #if a cassette doesn’t exist, VCR will record a new one
  c.default_cassette_options = { record: :new_episodes }
  #integrates VCR with RSpec
  c.configure_rspec_metadata!
end

# Update settings if this is an integration test
if ENV['INTEGRATION_TEST']
  #Turn off VCR and prevent errors for missing cassettes
  VCR.turn_off!(:ignore_cassettes => true)
  #Enable webmock connections
  WebMock.allow_net_connect!
end
