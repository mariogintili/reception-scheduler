class Employee
  MAX_HOURS = 40
  attr_accessor :shifts

  def initialize
    @shifts = []
  end

  def add!(shift:)
    raise StandardError.new("An employee can work a maximum of 40 hours per week") if exceeds_allowed_hours?(shift: shift)
    raise StandardError.new("The new shift collides with the employee's schedule") if collides?(shift: shift)
    shifts.push(shift)
  end

  def hours_in_week(new_shift:)
    [new_shift, shifts].flatten.reduce(0) do |memo, committed|
      if committed.start.beginning_of_week == new_shift.start.beginning_of_week
        memo + committed.hours
      else
        memo
      end
    end
  end

  def collides?(shift:)
    shifts.any? do |existing_shift|
      (shift.start..shift.finish).include?(existing_shift.start) || (shift.start..shift.finish).include?(existing_shift.finish)
    end
  end

  private

  def exceeds_allowed_hours?(shift:)
    hours_in_week(new_shift: shift) > MAX_HOURS
  end
end
