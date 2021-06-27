# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  address         :string(255)
#  send_day_offset :integer
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  send_hour       :integer
#

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :venue do
    name { Faker::Name.first_name }
    address {
      Faker::Address.street_address +
        " "  + Faker::Address.city +
        ", " + Faker::Address.state_abbr
    }
    send_day_offset { 0 }
    send_hour { 17 }
    notes { "Venue notes." }
  end

  trait :send_early do
    send_day_offset { 1 }
  end
end
