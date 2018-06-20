class Shift
  MAX = 8
  attr_accessor :start, :finish

  def initialize(start:, finish:)
    @start  = start
    @finish = finish
    validate!(start: start, finish: finish)
  end

  def hours
    ((finish - start) / 3600).round
  end

  private

  def validate!(start:, finish:)
    any_time_is_in_the_past  = (start.past? || finish.past?)
    finish_date_before_start = (start > finish)
    too_long                 = hours > MAX

    raise StandardError.new("You can't set a shift in the past") if any_time_is_in_the_past
    raise StandardError.new("The finish date can't be a time before the start date") if finish_date_before_start
    raise StandardError.new("A shift can be only up to #{Shift::MAX} hours long") if too_long
  end
end
