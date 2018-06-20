require "spec_helper"

RSpec.describe Shift, type: :entity do
  describe "#initialize" do
    context "with an amount less than or equal to 8" do
      let(:start) { 1.hours.from_now }
      let(:finish) { 4.hours.from_now }

      subject do
        described_class.new(start: start, finish: finish)
      end

      it "assigns a start and a finish" do
        expect(subject.start).to eq(start)
        expect(subject.finish).to eq(finish)
      end
    end

    context "with times set in the past" do
      it "raises an exception" do
        expect { described_class.new(start: 3.hours.ago, finish: 4.hours.from_now) }.to raise_error(StandardError, "You can't set a shift in the past")
        expect { described_class.new(start: 10.hours.from_now, finish: 3.hours.ago) }.to raise_error(StandardError, "You can't set a shift in the past")
      end
    end

    context "with a start date that's after the end date" do
      subject do
        described_class.new(start: 10.hours.from_now, finish: 3.hours.from_now)
      end

      it "raises an exception" do
        expect { subject }.to raise_error(StandardError, "The finish date can't be a time before the start date")
      end
    end

    context "with an amount of hours greater than 8" do
      subject do
        described_class.new(start: 1.hour.from_now, finish: 12.hours.from_now)
      end
      it "raises an exception" do 
        expect { subject }.to raise_error(StandardError, "A shift can be only up to #{Shift::MAX} hours long")
      end
    end
  end
end
