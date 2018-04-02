require_relative 'params_processor'

# doc
class Response
  attr_reader :message, :response_url
  attr_accessor :request
  extend Forwardable

  delegate %i[user_name channel text] => :processor
  delegate %i[icon_emoji bot_name] => :message

  def initialize(request, params, message)
    @request = request
    @params  = params
    @message = message
    @response_url = params[:response_url]
    @processor = processor
  end

  def construct_message
    message.construct_message(text, user_name)
  end

  private

  def processor
    @processor ||= ParamsProcessor.new(@request, @params)
  end
end
