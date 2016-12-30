
class CheckUnnotifiedUsersAreWorkingJob < ActiveJob::Base
  queue_as :default

  def perform(user)
  end
end
