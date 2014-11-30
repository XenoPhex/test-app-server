require 'sinatra'
require 'newrelic_rpm'
require 'curl'
require 'json'

SLEEPER_API_URL = "http://sleeper-api.cfapps.io"

get '/' do
    "Welcome to the test app!"
end

get '/env' do
  headers 'Content-Type' => 'text/plain'
  "ENV Vars:\n#{`env`.chomp}"
end

get '/remote_wait/:sleep_time' do |sleep_time|
  result = JSON::parse(Curl.get("#{SLEEPER_API_URL}/#{sleep_time}").body_str)

  headers 'Content-Type' => 'text/json'
  {
    remote_wait: sleep_time,
    success: result['sleep_time'] && result['sleep_time'].to_s == sleep_time
  }.to_json
end

get '/simulate_stats' do
  # Based on Week's average on 11/14/2014 @ 11AM PST
  Curl.get("#{SLEEPER_API_URL}/105") #domains
  Curl.get("#{SLEEPER_API_URL}/103") #instances
  Curl.get("#{SLEEPER_API_URL}/103") #stats
  Curl.get("#{SLEEPER_API_URL}/88")  #summary
  Curl.get("#{SLEEPER_API_URL}/64")  #app
  Curl.get("#{SLEEPER_API_URL}/57")  #env
  Curl.get("#{SLEEPER_API_URL}/56")  #routes
  Curl.get("#{SLEEPER_API_URL}/40")  #uaa
  Curl.get("#{SLEEPER_API_URL}/34")  #stacks
  Curl.get("#{SLEEPER_API_URL}/3")   #spaces
  Curl.get("#{SLEEPER_API_URL}/2")   #organizations
  Curl.get("#{SLEEPER_API_URL}/2")   #quota_definitions

  headers 'Content-Type' => 'text/json'
  { stats_simulation: 'sucessful' }.to_json
end
