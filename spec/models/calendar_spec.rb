# == Schema Information
#
# Table name: calendars
#
#  id               :integer          not null, primary key
#  url              :string(255)
#  name             :string(255)
#  default_location :string(255)
#  weeks_to_show    :integer          default(1)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Calendar do
  pending "add some examples to (or delete) #{__FILE__}"
end
