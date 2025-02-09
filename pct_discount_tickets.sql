-- Write a query to calculate the percentage of tickets sold at a discount per event category.

select
    e.event_category,
    count(t.ticket_id) as total_tickets_sold,
    count(case when t.discount_applied > 0 then t.ticket_id end) as discounted_tickets,
    round(
        (count(case when t.discount_applied > 0 then t.ticket_id end) * 100.0) / nullif(count(t.ticket_id), 0), 2
    ) as discount_percentage
from boompop.tickets t
left join boompop.events e on t.event_id = e.event_id
group by e.event_category
order by discount_percentage desc;
