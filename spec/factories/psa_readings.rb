# == Schema Information
#
# Table name: psa_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  psa_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :psa_reading do
    user
    psa
  end
end
