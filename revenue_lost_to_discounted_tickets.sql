-- Calculate the total revenue lost due to discounts for each event category (assuming the difference between the original price and the discounted price).

select 
    e.event_category,
    sum(t.original_price - t.final_price) as total_revenue_lost,
    sum(t.original_price) as total_original_revenue,
    round(
        ((sum(t.original_price - t.final_price) * 100.0) / nullif(sum(t.original_price), 0))::numeric, 2
    ) as revenue_lost_percentage
from boompop.tickets t
left join boompop.events e 
    on t.event_id = e.event_id
where t.discount_applied > 0  -- discounted tickets only
group by e.event_category;
