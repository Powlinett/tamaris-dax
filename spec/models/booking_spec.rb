require 'rails_helper'

describe Booking do
  it { should belong_to(:booker) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }

  it { should validate_presence_of(:booker) }
  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:variant) }

  it 'validates presence and format of starting date' do
    booking = Booking.new

    expect(booking.starting_date.class).to eq(Date)
  end

  it 'validates presence and format of ending_date' do
    booking = Booking.new

    expect(booking.ending_date.class).to eq(Date)
  end

  it 'validates if booking last 3 days' do
    booking = Booking.new

    expect(booking.ending_date).to eq(booking.starting_date + 3)
  end

  it "validates if default actual state is 'pending'" do
    booking = Booking.new

    expect(booking.actual_state).to eq('pending')
  end

  it "sets booking's actual state as 'confirmed'" do
    booking = Booking.new

    booking.confirm

    expect(booking.actual_state).to eq('confirmed')
    expect(booking.former_state).to eq('pending')
  end

  it "sets booking's actual state as 'canceled'" do
    booking = Booking.new

    booking.cancel

    expect(booking.actual_state).to eq('canceled')
    expect(booking.former_state).to eq('pending')
  end

  it "sets booking's actual state as 'picked'" do
    booking = Booking.new
    booking.actual_state = 'confirmed'

    booking.pick_up

    expect(booking.actual_state).to eq('picked')
    expect(booking.former_state).to eq('confirmed')
  end

  it "sets booking's actual state as 'back' when it was 'pending'" do
    booking = Booking.new

    booking.back_in_stock

    expect(booking.actual_state).to eq('back')
    expect(booking.former_state).to eq('pending')
  end

  it "sets booking's actual state as 'back' when it was 'confirmed'" do
    booking = Booking.new
    booking.actual_state = 'confirmed'

    booking.back_in_stock

    expect(booking.actual_state).to eq('back')
    expect(booking.former_state).to eq('confirmed')
  end

  it 'closes a booking when ending date is passed' do
    booking = Booking.new(starting_date: Date.today - 4)

    booking.is_closed?

    expect(booking.is_closed?).to eq(true)
    expect(booking.former_state).to eq('pending')
    expect(booking.actual_state).to eq('closed')
  end
end
