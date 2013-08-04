FactoryGirl.define do
  sequence :username do |n|
    result = "AAA"
    n.times { result.succ! }
    result
  end

  factory :user, aliases: [:contest_director] do
    email { Faker::Internet.email }
    username
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
  end
end
