require 'bundler'
require 'json'
require 'net/ssh'

require_relative './models/hat_tip_message'
require_relative './models/late_message'
require_relative './models/slack_hook'
require_relative './models/ssh_message'
require_relative './models/time_off_message'

Bundler.require
Dotenv.load

def do_slack_hook(resp)
  sleep 5
  SlackHook.new(resp).post
end

def check_cmd(text)
  case text
  when "ps"
    "ps"
  when "restart plex", "restartplex"
    "restartplex"
  when "restart web", "restartweb"
    "restartweb"
  else
    "df"
  end
end

def do_ssh_server(resp)
  user = ENV['MEDIA_USER']
  server = ENV['MEDIA_SERVER']
  slack_cmd = check_cmd(resp.params[:text])
  Net::SSH.start(server, user, forward_agent: true) do |ssh|
    remote_cmd = "./dockerstuff/owsley/scripts/slack-receiver.sh #{slack_cmd}"
    result = ssh.exec!(remote_cmd)
    resp.override_text = result
    SlackHook.new(resp).post
  end
end

def in_channel(text)
  { response_type: 'in_channel', text: text }.to_json
end

def check_authz_channels
  ENV['AUTHZ_CHANNELS'].split(' ').include? params[:channel_id]
end

def check_authz_users
  ENV['AUTHZ_USERS'].split(' ').include? params[:user_id]
end

before do
  halt 401, "invalid token" unless params[:token] == ENV['SLACK_SHARED_SECRET']
  halt 403, "invalid user" unless check_authz_users
  halt 407, "invalid channel" unless check_authz_channels
end

post '/late' do
  response = Response.new(request, params, LateMessage.new)
  Thread.new { do_slack_hook(response) }
  content_type :json
  body in_channel("superman")
end

post '/server' do
  response = Response.new(request, params, SshMessage.new)
  Thread.new { do_ssh_server(response) }
  content_type :json
  body in_channel("super-server")
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
