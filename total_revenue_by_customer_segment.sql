-- Additionally, use a window function to calculate the total revenue per customer segment while considering how customer segments change over time.

with customer_revenue as (
    select
        c.customer_segment,
        date_trunc('month', p.effective_when) as revenue_month,
        sum(t.final_price) as total_revenue_per_month,
        avg(t.final_price) as avg_revenue_per_customer
    from boompop.tickets t
    left join boompop.customers c 
        on t.customer_id = c.customer_id
    left join boompop.payments p 
        on t.payment_id = p.payment_id
    group by c.customer_segment, revenue_month
),

segment_ranking as (
    select
        customer_segment,
        revenue_month,
        total_revenue_per_month,
        sum(total_revenue_per_month) over (
            partition by customer_segment 
            order by revenue_month 
            rows between unbounded preceding and current row
        ) as running_total_revenue_by_customer_segment,
        round(
            avg(avg_revenue_per_customer) over (
                partition by customer_segment, revenue_month
            )::numeric, 2
        ) as avg_revenue_per_customer_seg,
        rank() over (
            partition by revenue_month 
            order by total_revenue_per_month desc
        ) as revenue_rank
    from customer_revenue
)

select 
    customer_segment,
    revenue_month,
    total_revenue_per_month,
    running_total_revenue_by_customer_segment,
    avg_revenue_per_customer_seg as avg_revenue_per_customer,
    revenue_rank
from segment_ranking
order by revenue_month, revenue_rank;

