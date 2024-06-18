class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
class AfterDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    other_date = record.public_send(options.fetch(:with))

    return if other_date.blank?

    if value < other_date
      record.errors.add(attribute, (options[:message] || "must be after #{options[:with].to_s.humanize}"))
    end
  end
end
class EitherOrValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    other_value = record.public_send(options.fetch(:with))

    return if other_value.blank?

    if value & other_value
      #record.errors.add(attribute, (options[:message] || "cannot be select at the same time as #{options[:with].to_s.humanize}"))
      record.errors.add(attribute, (options[:message] || "cannot be select at the same time as #{options[:with].to_s.humanize}"))
    end
  end
end
class IsSumOfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != options.fetch(:in).map{ |t| record[t] }.sum
      record.errors.add(attribute, (options[:message] || "doesn't reflect the sum of some values"))
      options.fetch(:in).map{ |t| record.errors.add(t, (options[:message] || "isn't summing correctly")) }
      return false
    end
    return true
  end
end
