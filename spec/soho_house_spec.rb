require "spec_helper"

RSpec.describe SohoHouse, type: :entity do
  subject do
    described_class.new
  end

  describe "#initialize" do
    it "assigns employees as an empty array" do
      expect(subject.send(:employees)).to eq([])
    end
  end

  describe "#add!" do
    context "when the employee has shifts outside of the house's working hours" do
      let(:employee) do
        mario = Employee.new
        mario.add!(shift: Shift.new(start: 1.day.from_now.beginning_of_day + 1.hours, finish: 1.day.from_now.beginning_of_day + 5.hours))
        mario
      end

      it "raises an exception" do
        expect { subject.add!(employee: employee) }.to raise_exception(StandardError, "The employee has shifts that exist outside of the working hour")
      end
    end

    context "when the employee has shifts colliding with an existing employee's shift" do
      let(:existing_employee) do
        mario = Employee.new
        start = 1.day.from_now.change(hour: 9)
        mario.add!(shift: Shift.new(start: start, finish: start + 5.hours))
        mario
      end

      let(:new_employee) do
        tim   = Employee.new
        start = 1.day.from_now.change(hour: 11)
        tim.add!(shift: Shift.new(start: start, finish: start + 7.hours))
        tim
      end

      it "raises an exception" do
        subject.add!(employee: existing_employee)
        expect { subject.add!(employee: new_employee) }.to raise_exception(StandardError, "The employee has shifts that collide with another employee's shifts")
      end
    end

    context "when the employee has valid shifts" do
      it "adds the employee to the employees collection" do
      end
    end
  end
end
