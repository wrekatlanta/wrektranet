# == Schema Information
#
# Table name: listener_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone      :string(255)
#  contest_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ListenerTicket do
  pending "add some examples to (or delete) #{__FILE__}"
end
