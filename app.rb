require 'bundler'
require_relative './models/hat_tip_message'
require_relative './models/late_message'
require_relative './models/slack_hook'
require_relative './models/time_off_message'
Bundler.require
Dotenv.load

post '/late' do
  response = Response.new(request, params, LateMessage.new)
  SlackHook.new(response).post
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
