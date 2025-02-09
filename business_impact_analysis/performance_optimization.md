# Performance Optimization 

## Indexes

To improve the efficiency of my queries, I can apply indexes to speed up joins, filtering, grouping, and sorting operations.

Because I make common use of `LEFT JOIN` to pull in information from different tables (and sources), this will become cumbersome as the tables grow. By adding an index to foreign keys of common table joins, we can improve efficiency.

### Suggested Indexes
Based on the queries created earlier, here are some suggested indexes: 

```
CREATE INDEX idx_tickets_customer_id ON boompop.tickets (customer_id);
CREATE INDEX idx_tickets_payment_id ON boompop.tickets (payment_id);
```

## Partitioning

Another way to improve efficiency is by using partitioning. Partitioning allows tables to be logically grouped in a way that aligns with common business logic, making queries more efficient.

For example, it is common to analyze payments by month. By partitioning the payments table on `DATE_TRUNC('month', effective_when)`, I can improve query performance when aggregating by month.

### Suggested partitions
Based on the queries created earlier, here is a suggested partition:

NOTE: To implement this, I must first add an explicit column in the payments table called `payment_month`, which is equivalent to `DATE_TRUNC('month', effective_when)`.

```
CREATE TABLE boompop.payments_partitioned (
    payment_id SERIAL PRIMARY KEY,
    customer_id INT,
    effective_when DATE NOT NULL,
    payment_month DATE NOT NULL,
    amount NUMERIC
) PARTITION BY RANGE (payment_month);
```

## Performance vs Data Accuracy

When querying large datasets, there is often a trade-off between performance and data accuracy.

For example, in the suggestion above about partitioning, this approach improves database performance when pulling payments by month. However, it reduces real-time accuracy because users would have to wait for an entire month to pass before querying finalized monthly data (i.e., you cannot query an incomplete current month’s data with 100% accuracy).

### Key Questions for Evaluating Performance vs. Data Accuracy

To determine the right balance for EventX’s data, I would ask the following questions:

- How important is it for this data to be as real-time as possible?
- How often does historical data change?
- How large is each table (i.e., how many rows per table)?
- Do we have enough compute resources to process real-time data efficiently?
