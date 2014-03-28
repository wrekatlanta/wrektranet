# == Schema Information
#
# Table name: contests
#
#  id                     :integer          not null, primary key
#  venue_id               :integer
#  age_limit              :integer
#  pick_up                :boolean
#  listener_ticket_limit  :integer
#  staff_ticket_limit     :integer
#  notes                  :text
#  created_at             :datetime
#  updated_at             :datetime
#  listener_plus_one      :boolean          default(FALSE)
#  staff_plus_one         :boolean          default(FALSE)
#  send_time              :datetime
#  sent                   :boolean          default(FALSE)
#  staff_count            :integer
#  listener_count         :integer
#  alternate_recipient_id :integer
#  name                   :string(255)
#  start_time             :datetime
#  public                 :boolean          default(TRUE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    venue
    name { Faker::Name.first_name + " " + Faker::Name.last_name }
    start_time { Time.zone.today.beginning_of_day + 1.day + 20.hours }
    age_limit 0
    pick_up false
    listener_ticket_limit 3
    staff_ticket_limit 3
    notes "Contest notes."

    trait :pick_up do
      pick_up true
    end

    trait :sent do
      sent true
    end
  end
end
