class Race < ActiveRecord::Base
  
  # id, heat, scout_1, scout_2, time1, time2
  
  belongs_to :scout_1,
             :class_name => "Scout",
             :foreign_key => "scout_1_id"
  
  belongs_to :scout_2,
             :class_name => "Scout",
             :foreign_key => "scout_2_id"

  after_initialize :init
  
  def init
    self.time1 ||= 0
    self.time2 ||= 0
  end
  
  def winner
    if time1 < time2 then
      scout_1
    elsif time2 < time1 then
      scout_2
    else
      nil
    end
  end
  
  def winner_name
    if winner.nil? then 
      ""
    else
      winner.name
    end
  end
  
end
