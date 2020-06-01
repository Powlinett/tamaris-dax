require 'rails_helper'
include ActiveJob::TestHelper

describe Booking do
  it { should belong_to :booker }
  it { should belong_to :product }
  it { should belong_to :variant }

  it { should validate_presence_of :booker }
  it { should validate_presence_of :product }
  it { should validate_presence_of :variant }

  before(:all) do
    @booking = build(:booking)
  end

  describe '#confirm' do
    it "can be confirmed" do
      @booking.confirm

      expect(@booking.actual_state).to eq('confirmed')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#cancel' do
    it "can be canceled" do
      @booking.actual_state = 'pending'

      @booking.cancel

      expect(@booking.actual_state).to eq('canceled')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#pick_up' do
    it "sets booking's state to 'confirmed'" do
      @booking.actual_state = 'confirmed'

      @booking.pick_up

      expect(@booking.actual_state).to eq('picked')
      expect(@booking.former_state).to eq('confirmed')
    end
  end

  describe '#back_in_stock' do
    it "sets booking's state to 'back' when it was confirmed" do
      @booking.actual_state = 'confirmed'

      @booking.back_in_stock

      expect(@booking.actual_state).to eq('back')
      expect(@booking.former_state).to eq('confirmed')
    end

    it "sets a booking's state to 'back' when it was pending" do
      @booking.actual_state = 'pending'

      @booking.back_in_stock

      expect(@booking.actual_state).to eq('back')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#is_closed?' do
    it 'closes a booking when ending date is passed' do
      @booking.ending_date = Date.today - 1

      @booking.is_closed?

      expect(@booking.is_closed?).to eq(true)
      expect(@booking.actual_state).to eq('closed')
      expect(@booking.former_state).to eq('pending')
    end
  end

  describe '#set_defaults' do
    booking = Booking.new

    it 'sets default starting_date' do
      expect(booking.starting_date).to be_present
      expect(booking.starting_date.class).to eq(Date)
    end

    it 'sets default ending_date' do
      expect(booking.ending_date).to eq(@booking.starting_date + 3)
    end

    it 'sets booking duration to 3 days' do
      expect(booking.ending_date).to be_present
      expect(booking.ending_date.class).to eq(Date)
    end

    it "sets default actual state to 'pending'" do
      expect(booking.actual_state).to eq('pending')
    end
  end

  feature '#send_record_email' do
    it 'enqueues an e-mail when a booking is saved' do
      product = build(:product, reference: "1-1-22107-24-002")
      product.save
      variant = product.variants.last

      booking = create(:booking, product: product, variant: variant)

      expect(booking).to be_valid
      expect(enqueued_jobs.size).to eq(1)
    end
  end
end
