--SQL Advance Case Study


--Q1--BEGIN 
-- List all the states in which we have customers who have bought cellphones 
--from 2005 till today. 
select[Customer_Name],[State],YEAR(date) as Year from FACT_TRANSACTIONS AS t
join [dbo].[DIM_CUSTOMER] AS c on t.[IDCustomer]=c.IDCustomer
join [dbo].[DIM_LOCATION] As l on t.IDLocation=l.IDLocation
where YEAR(date) between 2005 and YEAR(getdate())





--Q1--END

--Q2--BEGIN
	--. What state in the US is buying the most 'Samsung' cell phones? 
	
select top 1  state,sum(Quantity)as Qty from  [DIM_LOCATION]  loc 
join[FACT_TRANSACTIONS] as trans on trans.IDLocation=loc.IDLocation
join [DIM_MODEL] mdl on trans.IDModel=mdl.IDModel
join [DIM_MANUFACTURER] mfc on mdl.IDManufacturer=mfc.IDManufacturer
where Country='US' and Manufacturer_Name= 'Samsung'
group by State
order by QTY desc











--Q2--END

--Q3--BEGIN      
	
	--Show the number of transactions for each model per zip code per state.
	select distinct( [IDModel]),[ZipCode],[State], COUNT (*) As transactions from [dbo].[FACT_TRANSACTIONS] AS trans
	join DIM_LOCATION As loc on trans.IDLocation= loc.IDLocation
	group by [IDModel],[ZipCode],[State]







--Q3--END

--Q4--BEGIN
--4. Show the cheapest cellphone (Output should contain the price also)


select  top 1 Model_name, min(Unit_price) as price from DIM_Model as mdl
group by Model_name
order by price ;

--Q4--END

--Q5--BEGIN



/*I want model_num in terms of avg pricing before that  
 that model_num has to filter which in terms we only want model_num whose manufacture quantity is in top 5*/
select mdl.IDModel  ,avg(unit_price) as avg_pricing ,count(Quantity) as qty from [dbo].[DIM_MODEL] as mdl 
join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
join [dbo].[FACT_TRANSACTIONS] as trans on mdl.IDModel= trans.IDModel
where [Manufacturer_Name] in(Select top 5 [Manufacturer_Name] from [dbo].[DIM_MODEL] as mdl 
                             join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
                             join [dbo].[FACT_TRANSACTIONS] as trans on mdl.IDModel= trans.IDModel
							 group by [Manufacturer_Name]
							 order by count(Quantity)desc)
group by mdl.IDModel
order by avg_pricing desc





--Q5--END

--Q6--BEGIN

select Customer_Name ,avg(trans.TotalPrice)as avg_amt from [dbo].[DIM_CUSTOMER] as cust
join [dbo].[FACT_TRANSACTIONS] as trans on cust.IDCustomer=trans.IDCustomer
where year(date) = 2009
group by Customer_Name
having avg(trans.TotalPrice)>500


    











--Q6--END
	
--Q7--BEGIN  
	

	select t1.model_name from (select top 5 model_name,dm.IDModel,sum(quantity) as qty from FACT_TRANSACTIONS ft
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel
where year(date)=2008
group by model_name,dm.IDModel
order by qty desc) as t1 inner join
(select top 5 model_name,dm.IDModel,sum(quantity) as qty from FACT_TRANSACTIONS ft
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel
where year(date)=2009
group by model_name,dm.IDModel
order by qty desc) as t2 on t1.Model_Name=t2.Model_Name inner join 
(select top 5 model_name,dm.IDModel,sum(quantity) as qty from FACT_TRANSACTIONS ft
inner join DIM_MODEL dm on ft.IDModel=dm.IDModel
where year(date)=2010
group by model_name,dm.IDModel
order by qty desc) as t3 on t2.model_name=t3.model_name


--- . List if there is any model that was in the top 5 in terms of quantity,  
---simultaneously in 2008, 2009 and 2010  


select * from(
select  top 5 Model_Name  from [DIM_MODEL] mdl
join [FACT_TRANSACTIONS] trans on mdl.IDModel=trans.IDModel
where YEAR(Date)=2008
group by  Model_Name
order by   sum(Quantity)  desc) as t1
INTERSECT
select * from (select  top 5 Model_Name from [DIM_MODEL] mdl
join [FACT_TRANSACTIONS] trans on mdl.IDModel=trans.IDModel
where YEAR(Date)=2009
group by  Model_Name
order by   sum(Quantity) desc)as t2
intersect
select * from (select  top 5 Model_Name  as QTY from [DIM_MODEL] mdl
join [FACT_TRANSACTIONS] trans on mdl.IDModel=trans.IDModel
where YEAR(Date)=2010
group by  Model_Name
order by  sum(Quantity) desc) as t3 














--Q7--END	
--Q8--BEGIN
select * from(
select top 1 *from
(select top 2[Manufacturer_Name],[Model_Name] ,YEAR(date) as date,sum(TotalPrice) as TotalPrice from  [dbo].[DIM_MODEL] as mdl
join [dbo].[FACT_TRANSACTIONS] as trans on trans.IDModel=mdl.IDModel
join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
where YEAR(date)=2009
group by  [Manufacturer_Name],[Model_Name] ,YEAR(date)
order by sum(TotalPrice)desc )as t1
order by TotalPrice)as t3
union

select top 1 * from (select top 2 [Manufacturer_Name],[Model_Name] ,YEAR(date) as date, sum(TotalPrice) as TotalPrice from  [dbo].[DIM_MODEL] as mdl
join [dbo].[FACT_TRANSACTIONS] as trans on trans.IDModel=mdl.IDModel
join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
where YEAR(date)=2010
group by  [Manufacturer_Name],[Model_Name] ,YEAR(date)
order by sum(TotalPrice) desc)as t2
order by TotalPrice















--Q8--END
--Q9--BEGIN
--Show the manufacturers that sold cellphones in 2010 but did not in 2009	
select [Manufacturer_Name] from [dbo].[DIM_MODEL] as mdl
join [dbo].[FACT_TRANSACTIONS] as trans on trans.IDModel=mdl.IDModel
join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
where year(Date)=2010
group by [Manufacturer_Name]
except
select [Manufacturer_Name] from [dbo].[DIM_MODEL] as mdl
join [dbo].[FACT_TRANSACTIONS] as trans on trans.IDModel=mdl.IDModel
join [dbo].[DIM_MANUFACTURER] as mfc on mfc.IDManufacturer=mdl.[IDManufacturer]
where YEAR(date)=2009
group by [Manufacturer_Name]


















--Q9--END

--Q10--BEGIN
	
/*	 Find top 100 customers and their average spend, average quantity by each  
year. Also find the percentage of change in their spend. */

select *,((avg_price-lag_price)/lag_price) from(
select *, LAG(avg_price,1) over (partition by IDCustomer order by year) as lag_price from(
SELECT IDCustomer,avg(totalprice) avg_price,avg(quantity) avg_qty,YEAR(date)  as year FROM FACT_TRANSACTIONS
where IDCustomer in (select top 100 IDCustomer  from FACT_TRANSACTIONS
                          group by IDCustomer
						  order by SUM(totalprice) desc)
GROUP BY IDCustomer,YEAR(date)
)as A
)as B
















--Q10--END
	