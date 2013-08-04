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
  has_many :contacts

  attr_accessible :name, :fax, :address, :send_day_offset, :notes,
                  :send_hour, :send_minute

  validates :name, :presence => true
  validates :fax, :format => /[\(\)0-9\- \+\.]{10,20}/, :allow_blank => true
  validates :send_hour, :inclusion => 0..23
  validates :send_minute, :inclusion => 0..59

  # FIXME: make this generic
  def strip_fax
    self.fax.gsub!(/\D/, '')
  end

  def fax_formatted
    digits = self.fax

    if (digits.length == 11 and digits[0] == '1')
      # Strip leading 1
      digits.shift
    end

    if (digits.length == 10)
      '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
    end
  end
end
