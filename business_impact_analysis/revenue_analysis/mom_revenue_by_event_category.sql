-- Calculate the percentage change in total revenue month-over-month for each event category.

with monthly_revenue as (

    select 
        e.event_category,
        date_trunc('month', e.start_date)::date as revenue_month,
        sum(er.total_ticket_sales) as total_revenue
    from boompop.event_revenue er
    left join boompop.events e on er.event_id = e.event_id
    group by e.event_category, revenue_month

),

revenue_with_lag as (

    select
        event_category,
        revenue_month,
        total_revenue,
        lag(total_revenue) over (
            partition by event_category 
            order by revenue_month
        ) as previous_month_revenue
    from monthly_revenue

)

select
    event_category,
    revenue_month,
    total_revenue,
    previous_month_revenue,
    round(
        ((total_revenue - previous_month_revenue) * 100.0 / nullif(previous_month_revenue, 0))::numeric, 2
    ) as revenue_mom_percentage_change
from revenue_with_lag
order by event_category, revenue_month;
