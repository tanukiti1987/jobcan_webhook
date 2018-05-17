require 'redis'
require 'redis-namespace'
require 'sidekiq'

require_relative '../lib/init'
require_relative '../models/init'

class ClockInWorker
  include Sidekiq::Worker
  sidekiq_options queue: :event

  def perform(id)
    return if id.nil?

    authentication = ::Authentication.find_by(id: id)
    return if authentication.nil?

    jobcan = Jobcan.new(authentication)

    message =
      if jobcan.clock_in
        "出勤できました"
      else
        "出勤できませんでした"
      end

    authentication.slack_notification&.notify message
  end
end
