
class CheckUnnotifiedUsersAreWorkingJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    # invoke another job at your time of choice 
  end

  def perform(user)
    # NotificationMailer.catch_up(user)
  end
end
