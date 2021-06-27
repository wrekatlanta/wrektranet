# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  venue_id   :integer
#

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :contact do
    venue
    email { Faker::Internet.email }
  end
end
