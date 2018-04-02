# doc
class SshMessage
  def construct_message(text, user_name)
    <<~SOMEMESSAGE
      ssh results for #{user_name}
      ```
      #{text}
      ```
    SOMEMESSAGE
  end

  def icon_emoji
    ':turtle:'
  end

  def bot_name
    'Late-Bot'
  end
end
