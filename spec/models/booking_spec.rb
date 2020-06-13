require 'rails_helper'
include ActiveJob::TestHelper

describe Booking do
  it { should belong_to :booker }
  it { should belong_to :product }
  it { should belong_to :variant }

  it { should validate_presence_of :starting_date }
  it { should validate_presence_of :ending_date }
  it { should validate_presence_of :actual_state }

  before(:all) do
    product = create(:product, reference: "1-1-22107-24-607")
    @booking = create(:booking, product: product)
  end

  describe '#set_defaults' do
    it 'sets default starting_date' do
      expect(@booking.starting_date.class).to eq(Date)
    end

    it 'sets default ending_date' do
      expect(@booking.ending_date).to eq(@booking.starting_date + 3)
    end

    it 'sets booking duration to 3 days' do
      expect(@booking.ending_date.class).to eq(Date)
    end

    it "sets default actual state to 'pending'" do
      expect(@booking.actual_state).to eq('pending')
    end
  end

  describe '#confirm' do
    it "confirms the booking" do
      expect(@booking.variant).to_not eq(nil)
      @booking.confirm

      expect(@booking.actual_state).to eq('confirmed')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#cancel' do
    it "cancels the booking" do
      @booking.actual_state = 'pending'

      @booking.cancel

      expect(@booking.actual_state).to eq('canceled')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#pick_up' do
    it "updates booking's state to 'picked'" do
      @booking.actual_state = 'confirmed'

      @booking.pick_up

      expect(@booking.actual_state).to eq('picked')
      expect(@booking.former_state).to eq('confirmed')
    end
  end

  describe '#back_in_stock' do
    context 'when it was confirmed' do
      it "sets booking's state to 'back'" do
        @booking.actual_state = 'confirmed'

        @booking.back_in_stock

        expect(@booking.actual_state).to eq('back')
        expect(@booking.former_state).to eq('confirmed')
      end
    end

    context 'when it was pending' do
      it "sets booking's state to 'back'" do
        @booking.actual_state = 'pending'

        @booking.back_in_stock

        expect(@booking.actual_state).to eq('back')
        expect(@booking.former_state).to eq('pending')
      end
    end
  end

  describe '#is_closed?' do
    context 'when ending date is passed' do
      it "returns true" do
        @booking.ending_date = Date.today - 1
        @booking.actual_state = 'pending'

        expect(@booking.is_closed?).to be true
      end

      it "sets actual state as 'closed'" do
        expect(@booking.actual_state).to eq('closed')
      end

      it "sets former state as 'pending'" do
        expect(@booking.former_state).to eq('pending')
      end
    end

    context "when ending date isn't passed" do
      it "returns false" do
        @booking.reload
        @booking.ending_date = Date.today + 1
        @booking.actual_state = 'pending'

        expect(@booking.is_closed?).to be false
      end

      it "keeps actual state as 'pending'" do
        expect(@booking.actual_state).to eq('pending')
      end

      it "keeps former state as nil" do
        expect(@booking.former_state).to be nil
      end
    end
  end

  describe '#send_record_email' do
    it 'enqueues an e-mail when a booking is created' do
      expect{ create(:booking, product: Product.last) }.to change { enqueued_jobs.size }.by(1)
    end
  end
end
