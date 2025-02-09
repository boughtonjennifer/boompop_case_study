-- - Use window functions to calculate the cumulative revenue for each event category over time (from earliest to latest event).

select 
    e.event_category, 
    er.event_id,
    e.start_date,
    er.total_ticket_sales as event_revenue,
    sum(er.total_ticket_sales) over (
        partition by e.event_category 
        order by e.start_date
    ) as cumulative_revenue
from boompop.event_revenue er
    left join boompop.events e 
        on er.event_id = e.event_id
order by e.event_category, e.start_date;
