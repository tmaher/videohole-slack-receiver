require 'bundler'
require_relative './models/hat_tip_message'
require_relative './models/late_message'
require_relative './models/slack_hook'
require_relative './models/ssh_message'
require_relative './models/time_off_message'
require 'net/ssh'

Bundler.require
Dotenv.load

def do_slack_hook(resp)
  sleep 5
  SlackHook.new(resp).post
end

def do_ssh_server(resp)
  user = ENV['MEDIA_USER']
  server = ENV['MEDIA_SERVER']
  private_key = ENV['OWSLEY_SSH_PRIVATE_KEY']
  Net::SSH.start(server, user, key_data: [private_key]) do |ssh|
    result = ssh.exec!("hostname; uptime ; date")
    resp.override_text = result
    SlackHook.new(resp).post
  end
end

before do
  halt 401, "invalid token" unless params[:token] == ENV['SLACK_SHARED_SECRET']
end

post '/lateold' do
  response = Response.new(request, params, LateMessage.new)
  Thread.new { do_slack_hook(response) }
  body "superman"
end

post '/late' do
  response = Response.new(request, params, SshMessage.new)
  Thread.new { do_ssh_server(response) }
  body "dun ssh'd"
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
