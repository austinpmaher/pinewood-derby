class CreateRaceDetailsView < ActiveRecord::Migration
  def up
    execute %{
      create view race_details as
      select 
      scout.id as scout_id,
      scout.name as scout_name,
      race.id as race_id,
      race.heat as heat,
      'LEFT' as side,
      race.time1 as race_time,
      case when race.time1 < race.time2 then 1
      else 0
      end as wins,
      case when race.time1 > race.time2 then 1
      else 0
      end as losses,
      race.time2 - race.time1 as differential
      from races race, scouts scout
      where race.scout_1_id = scout.id
      union select 
      scout.id as scout_id,
      scout.name as scout_name,
      race.id as race_id,
      race.heat as heat,
      'RIGHT' as side,
      race.time2 as race_time,
      case when race.time2 < race.time1 then 1
      else 0
      end as wins,
      case when race.time2 > race.time1 then 1
      else 0
      end as losses,
      race.time1 - race.time2 as differential
      from races race, scouts scout
      where race.scout_2_id = scout.id
      order by scout_name
    }
  end

  def down
    execute %{
      drop view race_details
    }
  end
end
