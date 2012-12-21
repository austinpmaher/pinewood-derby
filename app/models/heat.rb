class Heat
  attr_accessor :id, :scout1, :scout2

  def initialize( id, a, b )
    @id = id
    @scout1 = a
    @scout2 = b
  end

  def to_s
    "(#{scout1}, #{scout2})"
  end
  
  def generate_races
    results = []
    results << Race.new( :heat => @id, :scout_1 => @scout1, :scout_2 => @scout2 )
    results << Race.new( :heat => @id, :scout_1 => @scout2, :scout_2 => @scout1 )
    results
  end
end
