require 'rails_helper'

RSpec.describe Booking, type: :model do

  describe "#no_show!" do
    subject { booking.no_show! }

    context "pending booking" do
      let(:lesson) { create(:lesson, starts_at: 1.day.ago) }
      let(:booking) { create(:booking, status: "pending", lesson: lesson ) }

      it { is_expected.to be_truthy }

      it "updates the booking status to 'no_show'" do
        subject
        expect(booking.status).to eq("no_show")
      end

      it "creates a NoShowCharge" do
        expect {
          subject
        }.to change { NoShowCharge.count }.from(0).to(1)
      end
    end

    context "cancelled booking" do
      let(:booking) { create(:booking, status: "cancelled") }

      it "raises an error" do
        expect {
          subject
        }.to raise_error("Cannot mark no show for `cancelled` bookings.")
      end
    end

    context "no_show booking" do
      let(:booking) { create(:booking, status: "no_show") }

      it "raises an error" do
        expect {
          subject
        }.to raise_error("Booking already marked as `no_show`.")
      end
    end

    context "completed booking" do
      let(:booking) { create(:booking, status: "completed") }

      it { is_expected.to be_truthy }

      it "updates the booking status to 'no_show'" do
        subject
        expect(booking.status).to eq("no_show")
      end
    end

    context "outside the standard no show window" do
      let(:lesson) { create(:lesson, starts_at: Time.now - (4.days + 60.minutes) ) }
      let(:booking) { create(:booking, status: "pending", lesson: lesson) }

      it { is_expected.to be_truthy }

      it "updates the booking status to 'no_show'" do
        subject
        expect(booking.status).to eq("no_show")
      end

      it "does not create a NoShowCharge" do
        expect {
          subject
        }.to_not change { NoShowCharge.count }
      end
    end

    # context "lesson happened before the 5th of the current month" do
    #   before { Timecop.freeze(Date.new(2016,10,6)) }
    #   after { Timecop.return }

    #   let(:lesson) { create(:lesson, starts_at: Date.new(2016,9,25).to_time) }
    #   let(:booking) { create(:booking, status: "completed", lesson: lesson) }

    #   it "creates a billing adjustment" do
    #     expect {
    #       subject
    #     }.to change { BillingAdjustment.count }.from(0).to(1)
    #   end
    # end

    # context "lesson happened after the 5th of the current month" do
    #   before { Timecop.freeze(Date.new(2016,10,20)) }
    #   after { Timecop.return }

    #   let(:lesson) { create(:lesson, starts_at: Date.new(2016,10,15).to_time) }
    #   let(:booking) { create(:booking, status: "completed", lesson: lesson) }

    #   it "does not create a billing adjustment" do
    #     expect {
    #       subject
    #     }.to_not change { BillingAdjustment.count }
    #   end
    # end

  end
end
