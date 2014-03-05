# == Schema Information
#
# Table name: ORGANIZATIONS
#
#  org_key          :string(11)       not null
#  org_type         :integer          not null
#  parent_key       :string(11)
#  org_name         :string(40)
#  address_line_1   :string(40)
#  address_line_2   :string(40)
#  city             :string(20)
#  state            :string(2)
#  zip              :string(5)
#  zipext           :string(4)
#  country          :string(20)
#  add_list         :string(1)
#  p_guide          :string(1)
#  contact_name     :string(40)
#  voice_phone      :string(15)
#  fax_phone        :string(15)
#  notes            :string(120)
#  e_mail           :string(60)
#  url_1            :string(80)
#  url_2            :string(80)
#  url_3            :string(80)
#  url_4            :string(80)
#  url_5            :string(80)
#  other_1          :string(100)
#  other_2          :string(100)
#  org_id           :integer          not null, primary key
#  automated_e_mail :string(60)
#

class Legacy::Organization < Legacy::OracleBase
  self.table_name = 'ORGANIZATIONS'

  has_many :albums
end
