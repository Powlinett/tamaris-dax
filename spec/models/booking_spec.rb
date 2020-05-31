require 'rails_helper'

describe Booking do
  it { should belong_to(:booker) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }

  it { should validate_presence_of(:booker) }
  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:variant) }
end

describe '#confirm' do
  it "can be confirmed" do
    booking = Booking.new

    booking.confirm

    expect(booking.actual_state).to eq('confirmed')
    expect(booking.former_state).to eq('pending')
  end
end

describe '#cancel' do
  it "can be canceled" do
    booking = Booking.new

    booking.cancel

    expect(booking.actual_state).to eq('canceled')
    expect(booking.former_state).to eq('pending')
  end
end

describe '#pick_up' do
  it "sets booking's state to 'confirmed'" do
    booking = Booking.new
    booking.actual_state = 'confirmed'

    booking.pick_up

    expect(booking.actual_state).to eq('picked')
    expect(booking.former_state).to eq('confirmed')
  end
end

describe '#back_in_stock' do
  it "sets booking's state to 'back' when it was confirmed" do
    booking = Booking.new
    booking.actual_state = 'confirmed'

    booking.back_in_stock

    expect(booking.actual_state).to eq('back')
    expect(booking.former_state).to eq('confirmed')
  end

  it "sets a booking's state to 'back' when it was pending" do
    booking = Booking.new

    booking.back_in_stock

    expect(booking.actual_state).to eq('back')
    expect(booking.former_state).to eq('pending')
  end
end

describe '#is_closed?' do
  it 'close a booking when ending date is passed' do
    booking = Booking.create(starting_date: Date.today - 4)

    booking.is_closed?

    expect(booking.is_closed?).to eq(true)
    expect(booking.actual_state).to eq('closed')
    expect(booking.former_state).to eq('pending')
  end
end

describe '#set_defaults' do
  it 'sets default starting_date' do
    booking = Booking.new

    expect(booking.starting_date).to be_present
    expect(booking.starting_date.class).to eq(Date)
    expect(booking.actual_state).to eq('pending')
  end

  it 'sets booking duration to 3 days' do
    booking = Booking.new

    expect(booking.ending_date).to be_present
    expect(booking.ending_date.class).to eq(Date)
  end

  it "sets default actual state to 'pending'" do
    booking = Booking.new

    expect(booking.ending_date).to eq(booking.starting_date + 3)
  end
end

feature '#send_record_email' do
  it 'sends an e-mail when a booking is saved' do
    product_feature = ProductFeature.create(
                        features_hash: {
                          "Numéro d'article"=>"30162-420",
                          "Extérieur"=>"Polyester",
                          "Doublure"=>"Polyester",
                          "Dimensions"=>"16 x 16 x 16 cm"
                        }
                      )
    product = Product.create(
                reference: "30162-660",
                model: "Sacs à bandoulière",
                color: "peach",
                category: "accessoires",
                sub_category: "sacs",
                price: 45.95,
                former_price: 0.0,
                sizes_range: [1],
                product_feature: product_feature
              )
    variant = product.variants.first
    email = Faker::Internet.email
    booker = Booker.create(
                email: email,
                email_confirmation: email,
                phone_number: "0612345678",
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name
                )
    booking = Booking.create(
                product: product,
                variant: variant,
                booker: booker
              )

    email = open_email(booker.email)

    expect(product_feature).to be_valid
    expect(product).to be_valid
    expect(variant).to be_valid
    expect(booking).to be_valid
    expect(booker).to be_valid
    expect(email.subject).to eq('Votre réservation sur Tamaris-Dax')
  end
end
