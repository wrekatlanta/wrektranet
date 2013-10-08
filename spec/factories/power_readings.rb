# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :power_reading do
    plate_current 1.5
    plate_voltage 1.5
    power_out 1.5
  end
end
