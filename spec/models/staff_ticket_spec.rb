# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_type        :integer
#  contest_director_id :integer
#  awarded             :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe StaffTicket do
  pending "add some examples to (or delete) #{__FILE__}"
end
