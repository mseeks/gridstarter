# Initializer for Barge(https://github.com/boats/barge) for the digital ocean api
DigitalOcean = Barge::Client.new do |config|
  config.access_token = ENV["DIGITAL_OCEAN_ACCESS_TOKEN"]
end
