# frozen_string_literal: true

require 'uri'

# docs
class ParamsProcessor
  attr_reader :params

  def initialize(request, params)
    # params[:channel_name] ||= 'testing'
    # params[:user_name] ||= 'somedude'
    # params[:text] ||= 'stuff'
    @request = request
    @params = params
    debug_log
  end

  def text
    text_values[0].include?(',') ? timeoff_text : text_values[0]
  end

  def channel
    text_values[1] || ('#' + params[:channel_name])
  end

  def user_name
    params[:user_name]
  end

  private

  def debug_log
    return unless ENV['DEBUG']
    STDERR.puts Hash[URI.decode_www_form(@request.body.read)].to_json
  end

  def text_values
    params[:text] ? params[:text].split(/(?=#)/).map(&:strip) : ['']
  end

  def timeoff_text
    text_values[0].delete(' ').gsub(',', ' through ')
  end
end
