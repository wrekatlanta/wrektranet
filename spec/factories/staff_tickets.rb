# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_director_id :integer
#  awarded             :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  display_name        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :staff_ticket do
    contest
    user
    awarded false

    trait :awarded do
      awarded true
      user
    end
  end
end
