# == Schema Information
#
# Table name: listener_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone      :string(255)
#  contest_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :listener_ticket do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    contest
    user
  end
end
