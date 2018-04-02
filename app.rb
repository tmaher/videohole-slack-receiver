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
  else
    "df"
  end
end

def do_ssh_server(resp)
  user = ENV['MEDIA_USER']
  server = ENV['MEDIA_SERVER']
  slack_cmd = check_cmd(resp.params[:text])
  Net::SSH.start(server, user, forward_agent: true) do |ssh|
    result = ssh.exec!("./do-a-thing.sh #{slack_cmd}")
    resp.override_text = result
    SlackHook.new(resp).post
  end
end

def in_channel(text)
  { response_type: 'in_channel', text: text }.to_json
end

before do
  halt 401, "invalid token" unless params[:token] == ENV['SLACK_SHARED_SECRET']
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
