# == Schema Information
#
# Table name: listener_logs
#
#  id         :integer          not null, primary key
#  hd2_128    :integer
#  main_128   :integer
#  main_24    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :listener_log do
    hd2_128 { 6 }
    main_128 { 6 }
    main_24 { 6 }
  end
end
