# == Schema Information
#
# Table name: calls
#
#  id         :integer          not null, primary key
#  time       :datetime
#  line       :integer
#  number     :string(255)
#  shortName  :string(255)
#  status     :string(255)
#  fullName   :string(255)
#  duration   :time
#  wait       :time
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Call do
  pending "add some examples to (or delete) #{__FILE__}"
end
