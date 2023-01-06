use [2021_olympics];


-- Athletes by countries and their coaches
select a.Name as Athlete, c.Name as Coach, a.NOC as NOC, a.Discipline as Discipline
from athletes a
left join coaches c
	on c.NOC=a.NOC and c.Discipline=a.Discipline
order by NOC;

-- Number of Entries by each country vs Total Entries
create view entries_by_country as
				Select y.NOC, y.Discipline, y.Entries_by_country, e.Total 
				from( select x.NOC, X.Discipline, count(x.Discipline)as Entries_by_country
							from(select a.Name as Athlete, c.Name as Coach, a.NOC as NOC, a.Discipline as Discipline
										from athletes a
										left join coaches c
											on c.NOC=a.NOC and c.Discipline=a.Discipline) x
							group by x.Discipline,x.NOC) y
				left join entries_gender e
					on y.Discipline= e.Discipline);

-- Ranking by % of Medals to Total_Entries for each country
select z.NOC,z.Total_Entries,z.Gold,z.Silver,z.Bronze,z.Total,z.Rank_by_Total
,left(cast(Round(z.MedalsPerEntry,2) as nvarchar(100)),4) as Percentage_Medals_to_Entries
, DENSE_RANK() over(order by z.MedalsPerEntry desc) as Rank_by_MPE
from(
	select * ,cast(y.Total as numeric)/cast(y.Total_Entries as numeric)*100 as MedalsPerEntry
		From (Select distinct NOC, Total_Entries, Gold, Silver, Bronze, Total, cast (m.Rank as int) as Rank_by_Total 
				from(select  NOC, sum(entries_by_country) as Total_Entries
					 from entries_by_country
					 group by NOC) x
				left join medals m
						on x.NOC= m.[Team/NOC]
				where m.Rank is not null) y) z
order by z.Rank_by_Total