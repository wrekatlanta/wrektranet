# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  fax             :string(255)
#  address         :string(255)
#  send_day_offset :integer
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  send_hour       :integer
#  send_minute     :integer
#

class Venue < ActiveRecord::Base
  before_save :strip_fax
  after_initialize :set_default_values

  has_many :contacts
  has_many :contests, dependent: :destroy, autosave: true

  validates :name, presence: true
  validates :fax, format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true
  validates :send_hour, inclusion: 0..23
  validates :send_minute, inclusion: 0..59

  private
    # FIXME: make this generic
    def strip_fax
      self.fax.gsub!(/\D/, '') if self.fax
    end

    def set_default_values
      self.send_hour ||= 17
      self.send_minute ||= 0
      self.send_day_offset ||= 0
    end
end
