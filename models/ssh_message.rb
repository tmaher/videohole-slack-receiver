# doc
class SshMessage
  def construct_message(text, user_name)
    <<~SOMEMESSAGE
      #{user_name} `/server ...` results
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
