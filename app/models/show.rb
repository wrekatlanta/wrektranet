# == Schema Information
#
# Table name: shows
#
#  id          :integer          not null, primary key
#  legacy_id   :integer
#  name        :string(255)
#  long_name   :string(255)
#  short_name  :string(255)
#  url         :string(255)
#  description :string(255)
#  email       :string(255)
#  facebook    :string(255)
#  twitter     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  priority    :integer
#

class Show < ActiveRecord::Base
end
