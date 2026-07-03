select * from 
(
select 
	job_name,
	run_datetime,
	SUBSTRING(run_duration, 1, 2) + ':' + SUBSTRING(run_duration, 3, 2) + ':' +	SUBSTRING(run_duration, 5, 2) AS run_duration,
	run_date
from
(
	select 
		job_name, 
		DATEADD(hh, -0, run_datetime) as run_datetime, 
		run_duration = RIGHT('000000' + CONVERT(varchar(6), h.run_duration), 6),
		t.run_date
	from
	(
		select 
			j.name as job_name 
			,run_datetime = (CONVERT(DATETIME, RTRIM(run_date)) +  (run_time * 9 + run_time % 10000 * 6 + run_time % 100 * 10) / 216e4)
			,h.run_date
		from msdb..sysjobhistory h
		inner join msdb..sysjobs j
		on h.job_id = j.job_id
		--group by j.name
	) t
	inner join msdb..sysjobs j
		on	t.job_name = j.name
	inner join msdb..sysjobhistory h
		on	j.job_id = h.job_id and 
			t.run_datetime = CONVERT(DATETIME, RTRIM(h.run_date)) + (h.run_time * 9 + h.run_time % 10000 * 6 + h.run_time % 100 * 10) / 216e4
) dt
) a where a.run_date = '20141028'
 order by a.run_datetime desc



