require_relative 'spec_helper'

describe ParamsProcessor do
  let(:data) do
    {
      token:        'KjRUKVRBoQVerm6bJTymvOe0',
      team_id:      'T0001',
      team_domain:  'example',
      channel_id:   'C2147483705',
      channel_name: 'default_channel',
      user_id:      'U2147483697',
      user_name:    'Steve',
      command:      '/late',
      text:         '10AM'
    }
  end

user_profile_resp =<<-EOT
{
  "ok": true,
  "profile": {
    "title": "break things",
    "phone": "",
    "skype": "",
    "real_name": "mystery guest",
    "real_name_normalized": "mystery guest",
    "display_name": "mystery guest",
    "display_name_normalized": "mystery guest",
    "fields": [],
    "status_text": "",
    "status_emoji": "",
    "status_expiration": 0,
    "email": "user@example.com",
    "first_name": "mystery",
    "last_name": "guest"
  }
}
EOT

  let(:subject) { described_class.new(nil, data) }

  before do
    stub_request(:post, "https://slack.com/api/users.profile.get")
      .to_return(status: 200, body: "", headers: {})
  end

  it 'parses user name' do
    expect(subject.user_name).to eq('<@U2147483697>')
  end

  it 'parses message text' do
    expect(subject.text).to eq('10AM')
  end

  it 'parses default channel' do
    expect(subject.channel).to eq('#default_channel')
  end

  it 'parses custom channel' do
    data[:text] = '10AM #other_channel'
    expect(subject.channel).to eq('#other_channel')
  end

  it 'parses no text' do
    data[:text] = nil
    expect(subject.channel).to eq('#default_channel')
    expect(subject.text).to eq('')
  end

  it 'parses timeoff text for one day' do
    data[:text] = "Monday"
    expect(subject.text).to eq('Monday')
  end

  it 'parses timeoff text for two days with a space' do
    data[:text] = "Monday, Tuesday"
    expect(subject.text).to eq('Monday through Tuesday')
  end

  it 'parses timeoff text for two days without a space' do
    data[:text] = 'Monday,Wednesday'
    expect(subject.text).to eq 'Monday through Wednesday'
  end
end
