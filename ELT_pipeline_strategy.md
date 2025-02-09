# ELT Strategy Proposal

## Architecture 

| **Component**               | **Tool**        | **Reasoning** |
|-----------------------------|----------------|----------------------|
| **Data Extraction & Loading**  | Fivetran    | Automates ingestion from multiple sources (ticket sales, marketing platforms, payments) with incremental updates and schema change handling. Connects well to Snowflake.|
| **Data Warehouse**            | Snowflake   | Scalable, high-performance cloud data warehouse that integrates seamlessly with dbt and supports incremental loads and late-arriving data efficiently. |
| **Data Transformation**       | dbt | Enables modular SQL transformations, incremental models, and data quality checks within Snowflake, eliminating the need for complex ETL pipelines. Very easy to set up & teach others. |
| **Orchestration & Deployment** | dbt Cloud  | dbt Cloud’s scheduling, monitoring, and alerting capabilities remove the need for external orchestrators like Airflow (until ML or streaming is needed). |

## Incremental Updates

Fivetran auto-detects new & updated records using updated_at timestamps or Change Data Capture (CDC). Additionally, at the analytics layer, dbt’s incremental materializations allow models to process only new or updated rows.

## Late-Arriving Data

Fivetran re-syncs recent historical data (within a configurable window) to capture missed updates based on prior knowledge of the possibilities and uses soft deletes (is_deleted flags) to prevent data loss.

## Fault Tolerance & Scalability

Snowflake’s auto-scaling warehouses dynamically allocates resources to handle large queries. 
