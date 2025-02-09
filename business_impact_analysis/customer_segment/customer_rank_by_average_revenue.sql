-- Use window functions to calculate the rank of each customer segment by average revenue (rank segments in descending order of average revenue)

with customer_revenue as (

    select
        c.customer_segment,
        round(avg(t.final_price)::numeric, 2) as avg_revenue_per_customer
    from boompop.tickets t
    left join boompop.customers c 
        on t.customer_id = c.customer_id
    group by c.customer_segment

)

select
    customer_segment,
    avg_revenue_per_customer,
    rank() over (
        order by avg_revenue_per_customer desc
    ) as revenue_rank
from customer_revenue;
