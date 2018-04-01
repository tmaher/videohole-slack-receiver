require 'bundler'
require_relative './models/hat_tip_message'
require_relative './models/late_message'
require_relative './models/slack'
require_relative './models/time_off_message'
Bundler.require
Dotenv.load

post '/late' do
  response = Response.new(request, params, LateMessage.new)
  Slack.new(response).post
end

post '/timeoff' do
  response = Response.new(request, params, TimeOffMessage.new)
  Slack.new(response).post
end

post '/hat_tip' do
  response = Response.new(request, params, HatTipMessage.new)
  Slack.new(response).post
end

get '/' do
  markdown :index
end
