# == Schema Information
#
# Table name: psas
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  body            :text
#  status          :string(255)
#  expiration_date :date
#  created_at      :datetime
#  updated_at      :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :psa do
    title "Chad Kroger Alert"
    body "Chad Kroger is very horny today."
    status "new"
    expiration_date Date.tomorrow
  end
end
