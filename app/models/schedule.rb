class Schedule < ApplicationRecord

  has_one :user, dependent: :destroy

  validates_presence_of [:user, :start, :end]

  def is_during_work?
    # sanity check
    return false if !is_a_working_day?(user_time.wday)

    user_hour = self.user_time.hour
    user_min = self.user_time.min

    if user_hour <= self.end.hour && user_hour >= self.start.hour
      # if true we need to check minutes
      if user_hour == self.end.hour
        return false if user_min > 0
      end
      return true
    end
    return false
  end

  # hours
  def is_available_in

    user_hour = self.user_time.hour
    user_wday = self.user_time.wday

    # available no waiting
    if is_during_work?
      return 0
    else
      if next_working_day(user_wday) < 0
        # it seems we are unemployed
        return -1
      else
        # -1 because we assume start time is always the next day
        available_in = (7 - user_wday + next_working_day(user_wday) -1) * 24
      end
      if user_hour < self.start.hour
        available_in += self.start.hour - user_hour
      else
        if user_hour >= self.start.hour
          available_in += 24 - user_hour + self.start.hour
        end
      end
      return available_in
    end
  end

  def next_working_day(weekday, count = 0)
    if is_a_working_day?(weekday)
      return weekday
    elsif count < 7
      if weekday < 7
        next_working_day(weekday+1, count+1)
      else
        next_working_day(0, count+1)
      end
    else
      # no work days in schedule
      return -1
    end
  end

  def is_a_working_day?(weekday)
    case weekday
    when 0
      sunday?
    when 1
      monday?
    when 2
      tuesday?
    when 3
      wednesday?
    when 4
      thursday?
    when 5
      friday?
    when 6
      saturday?
    else
      false
    end
  end

  def start=(attribute)
    time = Time.find_zone('UTC').parse(attribute)
    write_attribute(:start, time)
  end

  def end=(attribute)
    time = Time.find_zone('UTC').parse(attribute)
    write_attribute(:end, time)
  end

  protected

  def user_time
    Time.now.in_time_zone(user.time_zone)
  end
end
