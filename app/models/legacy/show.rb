# == Schema Information
#
# Table name: shows
#
#  id               :integer          not null, primary key
#  leader_id        :integer          default(0)
#  name             :string(100)      not null
#  short_name       :string(8)
#  url              :string(254)
#  show_description :text
#  show_type        :string(9)
#  email            :string(254)
#  updatedon        :timestamp        not null
#  updatedby        :integer
#  forecolor        :string(45)
#  backcolor        :string(45)
#  long_name        :string(45)
#  facebook         :string(254)
#  twitter          :string(254)
#

class Legacy::Show < Legacy::Base
  self.table_name = 'shows'

  has_many :show_schedules, primary_key: :id, foreign_key: :show_id

  default_scope -> { order('name ASC') }
  scope :specialty_shows, -> { where(show_type: 'specialty') }
  scope :oto_shows, -> { where(show_type: 'specialty') }
  scope :block_shows, -> { where(show_type: 'specialty') }
end
