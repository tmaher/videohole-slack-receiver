# Tom's Slack Receiver Hooks

## Heroku deploy instructions

```
git clone https://github.com/tmaher/slack-receiver
cd slack-receiver
git remote add heroku https://git.heroku.com/videohole-slack-receiver.git
heroku config:set ....   # see below
git push heroku master
```

## config vars
   * `DEBUG` - send debug messages to log
   * `AUTHZ_CHANNELS` - space-delimited list of Slack channel IDs (start with "G")
   * `AUTHZ_USERS` - space-delimited list of Slack user IDs (start with "U")
   * `MEDIA_SERVER` - DNS hostname of server (e.g. server.example.com)
   * `MEDIA_USER` - user to ssh in as (e.g. root, but plz don't use root)
   * `SERVER_SSH_PRIVATE_KEY` - unencrypted SSH private key to connect to server (`heroku config:set SERVER_SSH_PRIVATE_KEY="$(cat /path/to/key)"`)
   * `SLACK_API_TOKEN` - Slack app API token - see https://api.slack.com/docs/working-with-workspace-tokens
   * `SLACK_SHARED_SECRET` - The slash command's shared secret - see https://api.slack.com/slash-commands
