class String
  def to_boolean
    case self
      when "true"
        true
      when "false"
        false
    end
  end
end
