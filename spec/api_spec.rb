require_relative 'spec_helper'

describe 'API' do
  let(:data) do
    {
      token:        'KjRUKVRBoQVerm6bJTymvOe0',
      team_id:      'T0001',
      team_domain:  'example',
      channel_id:   'C2147483705',
      channel_name: 'other_channel',
      user_id:      'U2147483697',
      user_name:    'Steve',
      command:      '/timeoff',
      text:         'Monday'
    }
  end

  let(:app) { Sinatra::Application }

  before do
    stub_request(:post, 'www.example.com')
    expect(RestClient).to receive(:post)
    stub_request(:post, "https://slack.com/api/users.profile.get").
      with( body: {"token"=>nil, "user"=>"U2147483697"} ).
      to_return(status: 200, body: "", headers: {})
  end

  it 'POST /late' do
    post '/late', data
    expect(last_response).to be_ok
  end

  it 'POST /timeoff' do
    post '/timeoff', data
    expect(last_response).to be_ok
  end

  it 'POST /hat_tip' do
    post '/hat_tip', data
    expect(last_response).to be_ok
  end
end
