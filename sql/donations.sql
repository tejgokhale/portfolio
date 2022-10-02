with after as (
  select datepart(month, a.datecreated) as month, sum(a.amount) as after
  from m4ol_ea.tsm_tmc_contactscontributions_mfol a
  inner join m4ol_ea.tsm_tmc_contacts_mfol c on c.vanid = a.vanid
  where a.datecreated >= '2021-01-01' and a.datecreated <= '2021-12-31' and (a.createdby = 247 or a.createdby = 367) and c.datecreated >= '2021-01-01'
  group by 1
  order by 1 desc),

before as (
  select datepart(month, a.datecreated) as month, sum(a.amount) as before
  from m4ol_ea.tsm_tmc_contactscontributions_mfol a
  inner join m4ol_ea.tsm_tmc_contacts_mfol c on c.vanid = a.vanid
  where a.datecreated >= '2021-01-01' and a.datecreated <= '2021-12-31' and (a.createdby = 247 or a.createdby = 367) and c.datecreated < '2021-01-01'
  group by 1
  order by 1 desc)

select a.month, a.after as "Not Affiliated Before 2021", b.before as "Affiliated Before 2021"
from after a
inner join before b on b.month = a.month
