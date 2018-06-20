class SohoHouse
  CLOSING_HOURS = (3..7)
  attr_accessor :employees

  def initialize
    @employees = []
  end

  def shifts
    employees.map(&:shifts).flatten
  end

  def add!(employee:)
    raise StandardError.new("The employee has shifts that exist outside of the working hour") if out_of_working_hours?(employee: employee)
    raise StandardError.new("The employee has shifts that collide with another employee's shifts") if collides?(employee: employee)
    employees.push(employee)
  end

  private

  def collides?(employee:)
    employee.shifts.any? do |upcoming_shift|
      shifts.any? do |existing_shift|
        (upcoming_shift.start..upcoming_shift.finish).include?(existing_shift.start) || (upcoming_shift.start..upcoming_shift.finish).include?(existing_shift.finish)
      end
    end
  end

  def out_of_working_hours?(employee:)
    employee.shifts.any? do |shift|
      CLOSING_HOURS.include?(shift.start.hour) || CLOSING_HOURS.include?(shift.finish.hour)
    end
  end
end
