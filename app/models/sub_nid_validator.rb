#coding utf-8

class SubNidValidator < ActiveModel::EachValidator 
  def validate_each(record, attribute, value)
    @sub_nid_ary = value.split(nil)
    if @sub_nid_ary.first.length >= 20
      record.errors.add(:sub_nid, " : Target NetMask is no more than 20 characters.")
    end
  end 
end
