class Sector
  attr_accessor :min_value, :max_value, :mid_value, :sector

  def description
    "#{self.sector} | #{self.min_value}, #{self.mid_value}, #{self.max_value}"
  end
end