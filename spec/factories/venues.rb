# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name "Variety Playhouse"
    fax "+1-212-9876543"
    address {
      Faker::Address.street_address +
        " "  + Faker::Address.city +
        ", " + Faker::Address.state_abbr
    }
    send_day_offset 0
    send_hour 17
    send_minute 30
    notes "Cool man."
  end

  trait :send_early do
    send_day_offset 1
  end
end
