# frozen_string_literal: true

require_relative 'response'

# doc
class SlackHook
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def post
    STDERR.puts "POSTing to #{@response.response_url}"
    RestClient.post(@response.response_url, payload)
  end

  def payload
    {
      'text'       => response.construct_message,
      'channel'    => response.channel,
      'icon_emoji' => response.icon_emoji,
      'username'   => response.bot_name
    }.to_json
  end
end
