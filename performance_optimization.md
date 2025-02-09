# Performance Optimization 

## Indexes

To improve the efficiency of my queries, I can apply indexes to speed up joins, filtering, grouping, and sorting operations.

Because I make common use of the left join to pull in information from different tables (and sources), this will become cumbersome as the tables grow. By adding an index to foreign keys of common table joins, we can improve efficiency.

### Suggested indexes
Based on the queries created earlier, here are some suggested indexes: 

```
CREATE INDEX idx_tickets_customer_id ON boompop.tickets (customer_id);
CREATE INDEX idx_tickets_payment_id ON boompop.tickets (payment_id);
```

## Partitioning

Another way to improve efficiency is by use of partitions. Partitioning allows tables to be grouped in ways (that would be common based on business logic) so that when you perform that operation, it runs more efficiently. For example, it's a common business practice to want to know the sum or count of payments by  month. So, by partitioning the `payments` table on  `date_trunc('month', effective_when)`, we can improve the performance. 

### Suggested partitions
Based on the queries created earlier, here are is a suggested partition: 

NOTE: to do this, you'd first need to add an explicit column in the payments table that is `payment_month` (which is equivalent to `date_trunc('month', effective_when)`).

```
CREATE TABLE boompop.payments_partitioned (
    payment_id SERIAL PRIMARY KEY,
    customer_id INT,
    effective_when DATE NOT NULL,
    payment_month DATE NOT NULL,
    amount NUMERIC
) PARTITION BY RANGE (payment_month);
```


