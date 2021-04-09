#Total amount spent by each customer
select cust_code,sum(ord_amount) from orders group by cust_code;

#Total amount spent by each customer where agent_code is in(A001','A002','A003','A004') and order value is between 1000 and 2000
select cust_code,sum(ord_amount) as expense from orders where agent_code in ('A001','A002','A003','A004') group by cust_code having expense between 1000 and 2000;

#calculate yearly sales with rollup at month level
select year(ord_date) as yearly, month(ord_date) as monthly,sum(ord_amount) as expense from orders group by monthly, yearly with rollup;

#Common Table Expressions
#Find the details of top 5 representatives(from agents tables) based on total order value for each agent code in orders table

with formedTable as (
	select agent_code, sum(ord_amount) as exp from orders group by agent_code order by exp desc
)
select * from formedTable limit 5;

#WINDOW FUNCTION - FRAME UNIT (UNBOUNDED PRECEEDING, N-PRECEEDING, CURRENT ROW / UNBOUNDED FOLLOWING, N-FOLLOWING)
#WINDOW_FUNCTION_NAME(EXPRESSION) OVER(
# [PARTITION_DEFINITION]
# [FRAME_UNIT]
# )
# SELECT AGENT_CODE,ORD_AMOUNT SUM(ORD_AMOUNT) OVER(PARTITION BY AGENT_CODE ORDER BY ORD_AMOUNT ASC UNBOUNDED PRECEEDING AND UNBOUNDED FOLLOWING)

# SELECT ROW_NUMBER, AGENT_CODE, AGENT_NAME FROM AGENTS (CREATE ROWN NUMBER BASED ON AGENT_CODE COLUMN IN ASC)
select row_number() over(
	order by agent_code asc ) as SNO,agent_code,agent_name from agents; 

#select top 3 rank agents based on order value
with ranking as(
	select agent_code,sum(ord_amount) as exp from orders group by agent_code order by exp DESC
)
,ranked as(select dense_rank() over(order by exp DESC) as AgentRank,agent_code,exp from ranking)
select * from ranked where AgentRank<=3;
 
