use cars;

select * from cars;

--Get most_expensive, least_expensive and second_most_expensive cars in each year for each owner type
select x.year, x.owner,x.most_expensive_cars,x.Price_MEC,x.second_most_expensive,x.Price_SME,x.least_expensive_cars,x.Price_LEC
from (select year, owner
				,FIRST_VALUE(name) over(partition by owner, year order by selling_price) as most_expensive_cars
				,FIRST_VALUE(selling_price) over(partition by owner, year order by selling_price) as Price_MEC
				, lead(name,1,'No_Entry') over(partition by owner, year order by selling_price) as second_most_expensive
				, lead(selling_price,1,0) over(partition by owner, year order by selling_price) as Price_SME
				, LAST_VALUE(name) 
						over(partition by owner, year order by selling_price 
							range between unbounded preceding and unbounded following ) as least_expensive_cars
				, LAST_VALUE(selling_price) 
						over(partition by owner, year order by selling_price 
							range between unbounded preceding and unbounded following ) as Price_LEC
				,Dense_RANK() over(partition by owner, year order by selling_price) dense_ranking
		from cars) as x
where x.dense_ranking=2 or x.most_expensive_cars=x.least_expensive_cars
order by year desc;