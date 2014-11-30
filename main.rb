require 'sinatra'
require 'newrelic_rpm'
require 'curl'
require 'json'

get '/' do
    "Welcome to the test app!"
end

get '/env' do
  headers 'Content-Type' => 'text/plain'
  "ENV Vars:\n#{`env`.chomp}"
end

get '/remote_wait/:sleep_time' do |sleep_time|
  result = JSON::parse(Curl.get("http://sleeper-api.cfapps.io/#{sleep_time}").body_str)

  headers 'Content-Type' => 'text/json'
  {
    remote_wait: sleep_time,
    success: result['sleep_time'] && result['sleep_time'].to_s == sleep_time
  }.to_json
end
