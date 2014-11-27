require 'sinatra'

get '/' do
    "Welcome to the test app!"
end

get '/env' do
  headers 'Content-Type' => 'text/plain'
  "ENV Vars:\n#{`env`.chomp}"
end
