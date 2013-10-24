# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listener_log do
    hd2_128 6
    main_128 6
    main_24 6
  end
end
