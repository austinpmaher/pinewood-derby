
--
-- build views
--
drop view race_summary;

drop view race_details;

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


create view race_summary as
select scout_id, sum(wins) as wins, sum(losses) as losses, sum(differential) as differential
from race_details
group by scout_id

--
-- cleanup all the data
--

delete from races;
delete from scouts;
alter sequence scouts_id_seq restart with 1;
alter sequence races_id_seq restart with 1;

--
-- handy queries
--
select * from race_details order by scout_name, race_id;
select * from race_summary;

select scout_name, avg(race_time) as avg, stddev(race_time) as stddev, variance(race_time) as variance
from race_details group by scout_name
order by avg;

select side, sum(race_time) as total, avg(race_time) as average, sum(wins) as wins, sum(losses) as losses
from race_details where scout_id <> 5
group by side
