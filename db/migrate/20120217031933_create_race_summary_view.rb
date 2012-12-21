class CreateRaceSummaryView < ActiveRecord::Migration
  def up
    execute %{
      create view race_summary as
      select scout_id, sum(wins) as wins, sum(losses) as losses, sum(differential) as differential
      from race_details
      group by scout_id
    }
  end

  def down
    execute %{
      drop view race_summary
    }
  end
end
