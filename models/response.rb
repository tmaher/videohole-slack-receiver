require_relative 'params_processor'

class Response
  attr_reader :message
  extend Forwardable

  delegate [:user_name, :channel, :text] => :processor
  delegate [:icon_emoji, :bot_name] => :message

  def initialize(request, params, message)
    @request = request
    @params  = params
    @message = message
  end

  def construct_message
    message.construct_message(text, user_name)
  end

  private

  def processor
    @processor ||= ParamsProcessor.new(@params)
  end
end
