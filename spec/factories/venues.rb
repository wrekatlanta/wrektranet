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
    send_time "17:00"
    notes "Cool man."
  end

  trait :send_early do
    send_day_offset 1
  end
end
