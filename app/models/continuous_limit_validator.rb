#coding utf-8

class ContinuousLimitValidator < ActiveModel::EachValidator 
  def validate_each(record, attribute, value)
    @continuous_limit_ary = value.split(':')
    @continuous_limit_ary.each_with_index do |continuous_limit, index|
      begin
        Integer(continuous_limit)
      rescue ArgumentError
        record.errors.add(:continuous_limit, " : All fields must be number and required.")
        break
      end
      case index
      when 0
        if continuous_limit.to_i < 1 || 1000 < continuous_limit.to_i
          record.errors.add(:continuous_limit, " : nubmer must be from 1 to 1000.")
          break
        end     
      when 1
        if continuous_limit.to_i < 1 || 100 < continuous_limit.to_i
          record.errors.add(:continuous_limit, " : nubmer must be from 1 to 100.")
          break
        end    
      when 2
        if continuous_limit.to_i < 1 || 1000 < continuous_limit.to_i
          record.errors.add(:continuous_limit, " : nubmer must be from 1 to 1000.")
          break
        end    
      end
    end
  end
end
