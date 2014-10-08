# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)      not null
#  phone                  :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  display_name           :string(255)
#  status                 :string(255)
#  admin                  :boolean          default(FALSE)
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#  legacy_id              :integer
#  remember_token         :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  middle_name            :string(255)
#  birthday               :date
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  exec_staff             :boolean          default(FALSE)
#  user_id                :integer
#  subscribed_to_staff    :boolean
#  subscribed_to_announce :boolean
#  facebook               :string(255)
#  spotify                :string(255)
#  lastfm                 :string(255)
#  points                 :integer          default(0)
#

FactoryGirl.define do
  sequence :username do |n|
    result = "AAA"
    n.times { result.succ! }
    result
  end

  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password "password"
    password_confirmation "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    buzzcard_id 123456
    buzzcard_facility_code 1234

    trait :admin do
      admin true
    end

    trait :contest_director do
      after(:create) {|user| user.add_role(:contest_director)}
    end
  end
end
