-- Write a query to calculate the average revenue per customer segment.

select
    c.customer_segment,
    round(avg(t.final_price)::numeric, 2) as avg_revenue_per_customer
from boompop.tickets t
left join boompop.customers c 
    on t.customer_id = c.customer_id
group by c.customer_segment;
