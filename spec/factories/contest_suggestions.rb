# == Schema Information
#
# Table name: contest_suggestions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  venue      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  archived   :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest_suggestion do
    user
    name "George and the Burdells"
    date { Time.zone.today.beginning_of_day + 1.day }
    venue "Under the Couch"
  end
end
