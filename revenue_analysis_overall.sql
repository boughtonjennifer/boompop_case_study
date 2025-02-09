-- Write a query to calculate the total revenue per event category

select
    e.event_category, 
    sum(er.total_ticket_sales) as total_revenue
from boompop.event_revenue er
left join boompop.events e on er.event_id = e.event_id
group by e.event_category
order by total_revenue desc;
