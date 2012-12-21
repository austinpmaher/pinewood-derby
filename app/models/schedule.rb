require 'mathn'

class Schedule
  attr_accessor :scouts, :heats

  def self.generate

    webelos = ["Austin", "Jacob", "Sohil", "Joseph", "Lawrence"].collect do | name |
      Scout.new( :name => name, :car => "tbd" )
    end
    
    webelos.each{ | scout | scout.save }
    
    bears = ["Steven", "Alexander", "Stewart", "Dylan"].collect do | name |
      Scout.new( :name => name, :car => "tbd" )
    end
    
    bears.each{ | scout | scout.save }

    webelos_schedule = Schedule.new( webelos )
    bears_schedule = Schedule.new( bears )

    heats = merge_heats( webelos_schedule, bears_schedule )

    p "Heats"
    heats.each do | heat |
      heat.generate_races.each { | race | race.save }
      p heat
    end

    # p s.scout_heatmap

    #p "Max Idle Time"
    #p s.max_idle_time()

  end
  
  def self.merge_heats( webelos_schedule, bears_schedule)
    webelos_heats = webelos_schedule.heats
    bears_heats = bears_schedule.heats

    max = webelos_heats.length
    max = bears_heats.length if bears_heats.length > max

    heats = []
    0.upto(max - 1) do | idx |
      heats << webelos_heats[idx] if idx < webelos_heats.length
      heats << bears_heats[idx] if idx < bears_heats.length
    end
    
    heats
  end
  
  def initialize( scouts )
    @scouts = scouts
    @heats = build_schedule( scouts )
  end

  #
  # build a schedule by generating all combinations of scouts
  # and then shuffling over and over until a good one is found
  #
  # currently assumes there's going to be 5 scouts (or less)
  #
  def build_schedule( scouts )
    num_scouts = scouts.length
    base_iteration = generate_all_combinations( scouts )

    best_iteration = base_iteration
    best_score = 10000

    #    0.upto(1000) do | i |
    # testing has shown I can get all scouts to idle_max = 2
    # when there's 5 scouts
    it = 0
    while best_score > 2  && it < 10000 do
      it+=1
      iteration = base_iteration.shuffle
      heatmap = generate_heatmap( iteration )
      idle_map = compute_max_idle_time( heatmap )
      total_max = 0
      idle_map.each do | scout, max |
        total_max += max
      end
      score = total_max / num_scouts

      if score < best_score then
        best_iteration = iteration
        best_score = score
      end
      
    end

    best_iteration
  end

  def generate_all_combinations( scouts )
    # this could be replaced with scouts.combination(2).to_a, fwiw
    combinations = []
    last_idx = @scouts.length - 1
    heat_id = 0
    0.upto(last_idx-1) do | idx1 |
      (idx1 + 1).upto(last_idx) do | idx2 |
        heat_id += 1
        combinations.push Heat.new(heat_id, scouts[idx1], scouts[idx2])
      end
    end
    combinations
  end

  def scout_heatmap
    generate_heatmap( @heats )
  end

  def generate_heatmap( heats )
    heatmap = {}

    heats.each_with_index do | heat, idx |
      heat_number = idx + 1
      scout1 = heat.scout1
      scout2 = heat.scout2
      heatmap[scout1] = [ 0 ] if heatmap[scout1].nil?
      heatmap[scout2] = [ 0 ] if heatmap[scout2].nil?
      heatmap[scout1] << heat_number
      heatmap[scout2] << heat_number
    end

    # add sentinel to the end
    final = heats.length + 1
    heatmap.each_key do | scout |
      heatmap[scout] << final
    end

    heatmap
  end

  def compute_avg_idle_time( heatmap )
    results = {}
    heatmap.each do | scout, heats |
      idle = 0
      count = heats.length - 1
      1.upto(heats.length-1) do | idx |
        prev_heat = heats[idx - 1]
        curr_heat = heats[idx]
        idle += (curr_heat - prev_heat - 1)
      end
      avg = idle/count
      results[scout] = avg
    end
    results
  end

  def max_idle_time
    compute_max_idle_time( scout_heatmap )
  end

  def compute_max_idle_time( heatmap )
    results = {}
    heatmap.each do | scout, heats |
      max = 0
      1.upto(heats.length-1) do | idx |
        prev_heat = heats[idx - 1]
        curr_heat = heats[idx]
        idle = (curr_heat - prev_heat - 1)
        max = idle if idle > max
      end
      results[scout] = max
    end
    results
  end

end