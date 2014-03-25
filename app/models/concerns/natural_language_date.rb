require 'active_support/concern'
require 'chronic'

module NaturalLanguageDate
  extend ActiveSupport::Concern

  module ClassMethods
    def natural_language_date_attr(attribute, type = :datetime)
      getter = "#{attribute}_string".to_sym
      setter = "#{attribute}_string=".to_sym
      validator = "#{attribute}_string_is_date".to_sym

      define_method setter do |date_string|
        instance_variable_set("@#{getter}", date_string)
        self[attribute] = Chronic.parse(date_string)
      end

      define_method getter do
        case type
        when :date
          format = "%-m/%-d/%y"
        else
          format = "%-m/%-d/%y %-l:%M %p"
        end

        instance_variable_get("@#{getter}") || self.try(attribute).try(:strftime, format) || ''
      end

      define_method validator do
        date_string = self.send(getter)
        errors.add(getter, "is invalid") unless Chronic.parse(date_string)
      end
    end
  end
end