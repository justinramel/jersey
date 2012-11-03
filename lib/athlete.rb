class Athlete
  attr_accessor :period, :name, :miles, :hours, :minutes, :feet

  def feet_int
    self.feet.sub(',', '').to_i
  end

  def to_s
    "#{period}\t#{name}\t#{miles}mi\t#{hours}hr#{minutes}m\t#{feet}ft"
  end
end
