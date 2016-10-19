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
        expect(booking.no_show_charge.price).to eq(15)
      end
    end

    context "no_show booking" do
       let(:booking) { create(:booking, status: :no_show) }

       it "fails the validations" do
        expect {
          subject
        }.to_not change { NoShowCharge.count }

        expect(booking.errors[:base]).to include /Booking already marked as `no_show`/
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

  end
end
