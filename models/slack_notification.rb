class SlackNotification < ActiveRecord::Base
  belongs_to :authentication

  def notify(message)
    slack.post message
  end

  private

  def slack
    @slack ||= Slack::Incoming::Webhooks.new(
      webhook_url,
      channel: channel,
      username: 'Jobcan'
      )
  end
end
