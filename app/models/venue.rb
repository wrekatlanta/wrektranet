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
#

class Venue < ActiveRecord::Base
  after_initialize :set_default_values
  before_save :strip_fax
  after_update :update_contest_times

  has_many :contacts
  has_many :contests, dependent: :destroy

  accepts_nested_attributes_for :contacts, allow_destroy: true

  validates :name, presence: true
  validates :fax, format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true
  validates :send_hour, inclusion: 0..23, presence: true
  validates :send_day_offset, numericality: { greater_than_or_equal_to: 0 }, presence: true

  private
    # FIXME: make this generic
    def strip_fax
      self.fax.gsub!(/\D/, '') if self.fax
    end

    def update_contest_times
      if self.send_day_offset_changed? || self.send_hour_changed?
        self.contests.each do |contest|
          contest.set_send_time
          contest.save!
        end
      end
    end

    def set_default_values
      self.send_hour ||= 17
      self.send_day_offset ||= 0
    end
end
