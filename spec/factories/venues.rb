# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name { Faker::Name.first_name }
    address {
      Faker::Address.street_address +
        " "  + Faker::Address.city +
        ", " + Faker::Address.state_abbr
    }
    send_day_offset 0
    send_hour 17
    notes "Venue notes."
  end

  trait :send_early do
    send_day_offset 1
  end
end
