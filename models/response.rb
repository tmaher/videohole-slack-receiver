require_relative 'params_processor'

# doc
class Response
  attr_reader :message, :response_url
  attr_accessor :request, :override_text
  extend Forwardable

  delegate %i[user_name channel text] => :processor
  delegate %i[icon_emoji bot_name] => :message

  def initialize(request, params, message, override_text = nil)
    @request = request
    @params  = params
    @message = message
    @response_url = params[:response_url]
    @override_text = override_text
    @processor = processor
  end

  def construct_message
    message.construct_message(@override_text || text, user_name)
  end

  private

  def processor
    @processor ||= ParamsProcessor.new(@request, @params)
  end
end
