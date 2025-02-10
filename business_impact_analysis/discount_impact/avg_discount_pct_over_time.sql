-- Use window functions to find the moving average of the discount percentage (over the last 3 months) for each event category.

with monthly_discount_data as (

    select
        e.event_category,
        date_trunc('month', e.start_date)::date as revenue_month,
        count(t.ticket_id) as total_tickets_sold,
        count(case when t.discount_applied > 0 then t.ticket_id end) as discounted_tickets,
        round(
            (count(case when t.discount_applied > 0 then t.ticket_id end) * 100.0) / nullif(count(t.ticket_id), 0), 2
        ) as discount_percentage
    from boompop.tickets t
    left join boompop.events e on t.event_id = e.event_id
    group by e.event_category, revenue_month
),

moving_avg_discount as (

    select 
        event_category,
        revenue_month,
        discount_percentage,
        round(
            avg(discount_percentage) over (
                partition by event_category 
                order by revenue_month asc
                rows between 2 preceding and current row
            ), 2
        ) as rolling_3m_discount_pct
    from monthly_discount_data

)

select * 
from moving_avg_discount
order by event_category, revenue_month asc;
