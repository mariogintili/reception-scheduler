require "spec_helper"

RSpec.describe Employee, type: :entity do
  describe "#initialize" do
    it "assigns an empty list under #shifts" do
      expect(subject.instance_variable_get("@shifts")).to eq([])
    end
  end

  describe "#hours_in_week?" do
    let(:new_shift) { Shift.new(start: 2.days.from_now, finish: 2.days.from_now + 6.hours) }
    subject do
      employee = described_class.new
      employee.send(:shifts=, [Shift.new(start: 1.hours.from_now, finish: 5.hours.from_now)])
      employee
    end

    it "returns the number of hours in the week where the shift occurs" do
      expect(subject.hours_in_week(new_shift: new_shift)).to eq(10)
    end
  end

  describe "#collides?" do
    let(:existing_shift) { Shift.new(start: 1.day.from_now + 1.hours, finish: 1.day.from_now + 3.hours) }
    let(:new_colliding_shift) { Shift.new(start: 1.days.from_now, finish: 1.days.from_now + 6.hours) }
    let(:new_valid_shift) { Shift.new(start: 2.days.from_now, finish: 2.days.from_now + 5.hours) }

    subject do
      employee = described_class.new
      employee.send(:shifts=, [existing_shift])
      employee
    end

    describe "if the provided shift collides with an existing one" do
      it "returns true" do
        expect(subject.collides?(shift: new_colliding_shift)).to be_truthy
      end
    end

    describe "if it doesnt" do
      it "returns false" do
        expect(subject.collides?(shift: new_valid_shift)).to be_falsey
      end
    end
  end

  describe "#add!" do
    context "when the shift in that week's time would mean the employee exceeds 40 hours of work" do
      let(:extra_shift) { Shift.new(start: 1.hour.from_now, finish: 6.hours.from_now) }

      subject do
        described_class.new
      end

      before do
        allow(subject).to receive(:hours_in_week).with(new_shift: extra_shift) { 50 }
      end

      it "raises an exception" do
        expect { subject.add!(shift: extra_shift) }.to raise_error(StandardError, "An employee can work a maximum of 40 hours per week")
      end
    end

    context "when the shift is occuring in parallel to another shift" do
      let(:existing_shift) { Shift.new(start: 1.day.from_now + 1.hours, finish: 1.day.from_now + 3.hours) }
      let(:new_colliding_shift) { Shift.new(start: 1.days.from_now, finish: 1.days.from_now + 6.hours) }
      subject do
        employee = described_class.new
        employee.send(:shifts=, [existing_shift])
        employee
      end

      it "raises an exception" do
        expect { subject.add!(shift: new_colliding_shift) }.to raise_error(StandardError, "The new shift collides with the employee's schedule")
      end
    end

    context "when the shift to be added is valid and does not occur in parallel to another shift" do
      let(:existing_shift) { Shift.new(start: 1.day.from_now + 1.hours, finish: 1.day.from_now + 3.hours) }
      let(:new_valid_shift) { Shift.new(start: 2.days.from_now, finish: 2.days.from_now + 5.hours) }

      subject do
        employee = described_class.new
        employee.send(:shifts=, [existing_shift])
        employee
      end

      it "adds the shift to the employee" do
        subject.add!(shift: new_valid_shift)
        expect(subject.send(:shifts).length).to eq(2)
      end
    end
  end
end
