select datepart(year, datecreated::date)::varchar as year, count(*)
from m4ol_ea.tsm_tmc_contacts_mfol
where datecreated::date <= getdate() and datecreated::date >= '2021-01-01'
group by 1

union 

select datepart(year, datecreated::date)::varchar as year, count(*)
from m4ol_ea.tsm_tmc_contacts_mfol
where datecreated::date <= dateadd(year, -1, getdate()) and datecreated::date >= '2020-01-01'
group by 1

union 

select datepart(year, datecreated::date)::varchar as year, count(*)
from m4ol_ea.tsm_tmc_contacts_mfol
where datecreated::date <= dateadd(year, -2, getdate()) and datecreated::date >= '2019-01-01'
group by 1
