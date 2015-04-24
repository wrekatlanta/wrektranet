# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
#

# see this gem: https://github.com/huacnlee/rails-settings-cached
class Setting < RailsSettings::CachedSettings
end
