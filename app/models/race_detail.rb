class RaceDetail < ActiveRecord::Base
  
  set_table_name :race_details
  
  set_primary_key :scout_id
  
  def readonly?
    return true
  end
  
  belongs_to :scout,
             :class_name => "Scout",
             :foreign_key => "scout_id"

end
  