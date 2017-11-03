require 'slack/incoming/webhooks'

class SlackNotifier
  def initialize
  end

  def notify(message)
    slack.post message
  end

  private

  def slack
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_WEBHOOK_URL'], channel: '#sandbox', username: 'Jobcan'
  end
end
