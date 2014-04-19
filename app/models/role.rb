# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  full_name     :string(255)
#

class Role < ActiveRecord::Base
  # these are generated with `rake db:seed`
  # run 'cap deploy:seed' in production
  DEFAULT_ROLES = [
    { name: "general_manager",
      full_name: "General Manager"},
    { name: "operations_manager",
      full_name: "Operations Manager"},
    { name: "contest_director",
      full_name: "Contest Director"},
    { name: "psa_director",
      full_name: "PSA Director"},
    { name: "sports_director",
      full_name: "Sports Director"},
    { name: "faculty_advisor",
      full_name: "Faculty Advisor"},
    { name: "chief_engineer",
      full_name: "Chief Engineer"},
    { name: "assistant_chief_engineer",
      full_name: "Assistant Chief Engineer"},
    { name: "music_director",
      full_name: "Music Director"},
    { name: "public_affairs_director",
      full_name: "Public Affairs Director"},
    { name: "publicity_director",
      full_name: "Publicity Director"},
    { name: "business_manager",
      full_name: "Business Manager"},
    { name: "live_sound_director",
      full_name: "Live Sound Director"},
    { name: "automation_czar",
      full_name: "Automation Czar"},
    { name: "studio_director",
      full_name: "Studio Director"},
    { name: "news_director",
      full_name: "News Director"},
    { name: "traffic_director",
      full_name: "Traffic Director"},
    { name: "media_director",
      full_name: "Student Media Marketing and Advertising Director"},
    { name: "program_director",
      full_name: "Program Director"},
    { name: "it_director",
      full_name: "IT Director"},
    { name: "historian",
      full_name: "Historian"},
  ]

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  default_scope -> { order('full_name ASC') }
  
  scopify
end
