require 'bundler'
require_relative './models/hat_tip_message'
require_relative './models/late_message'
require_relative './models/slack_hook'
require_relative './models/time_off_message'
Bundler.require
Dotenv.load

def do_slack_hook(resp)
  sleep 5
  SlackHook.new(resp).post
end

before(/./) do
  shared_secret = ENV['SLACK_SHARED_SECRET']
  STDERR.puts "token is #{params[:token]}, secret #{shared_secret}"
  halt 403 unless params[:token] == shared_secret
end

post '/late' do
  response = Response.new(request, params, LateMessage.new)
  Thread.new { do_slack_hook(response) }
  body "superman"
end

post '/timeoff' do
  response = Response.new(request, params, TimeOffMessage.new)
  SlackHook.new(response).post
end

post '/hat_tip' do
  response = Response.new(request, params, HatTipMessage.new)
  SlackHook.new(response).post
end

get '/' do
  markdown :index
end
