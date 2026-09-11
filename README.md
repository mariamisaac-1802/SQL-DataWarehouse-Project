# Data Warehouse Project

A modern data warehousing solution built on the **medallion architecture** (Bronze → Silver → Gold), designed for reliable, repeatable batch processing of source data into analytics-ready models.

---

## Repository Description (short)

> A data warehouse implementing the medallion architecture (Bronze/Silver/Gold) with full data extraction, SCD Type 1 dimension handling, and a full load (truncate-and-insert) processing strategy.

---

## Overview

This project implements an end-to-end data warehouse that ingests raw data from source systems, progressively cleans and conforms it, and delivers curated, business-ready datasets for reporting and analytics. It follows the **medallion architecture** pattern, organizing data into three distinct layers of increasing quality and structure.

**Key characteristics:**
- **Full extraction** — each run pulls the complete dataset from source systems (no incremental/delta capture)
- **Full load strategy** — target tables are truncated and reloaded on every run
- **SCD Type 1** — dimension tables are overwritten in place; no historical versioning is retained

---

## Source & Acknowledgments

This project was built as a learning exercise, following the educational YouTube video: https://youtu.be/9GVqKuTVANE?si=pXWBO0x2rz7H-wCL

---

## Architecture

The warehouse is organized into three layers:

| Layer | Purpose | Characteristics |
|-------|---------|------------------|
| **Bronze** | Raw ingestion | Stores source data as-is, no transformations, preserves original structure |
| **Silver** | Cleansed & conformed | Data cleaning, standardization, type casting, deduplication, business rules applied |
| **Gold** | Business-ready | Star schema (facts & dimensions), aggregations, ready for BI/reporting tools |

Data flows sequentially from source systems into the Bronze layer, is refined into the Silver layer, and is finally modeled into the Gold layer for consumption by BI and reporting tools.

---

## Data Processing Strategy

This project uses a **full load** approach across all layers:

1. **Truncate** — target tables are cleared before each load
2. **Insert** — the complete, freshly extracted/transformed dataset is inserted

**Why full load?**
- Simplicity — no need to track deltas, watermarks, or CDC logs
- Consistency — every run produces a fully deterministic, reproducible result
- Suitable for source systems where the full dataset is small enough to reprocess efficiently

> **Note:** This strategy trades off processing efficiency for simplicity and reliability. For very large or rapidly growing source tables, an incremental strategy may be more appropriate in future iterations.

---

## Slowly Changing Dimensions (SCD Type 1)

Dimension tables in the Gold layer follow **SCD Type 1**:

- When a source record changes, the corresponding dimension record is **overwritten** with the new values
- **No history is preserved** — only the current/latest state of each dimension record is available
- Combined with the full load strategy, this means dimension tables are rebuilt from source truth on every run

This approach is well suited to attributes where historical tracking isn't a business requirement (e.g., correcting a typo in a customer's name or updating a product's category).

---

## Naming Conventions

### General Principles

- **Naming Conventions:** Use `snake_case`, with lowercase letters and underscores (`_`) to separate words.
- **Language:** Use English for all names.
- **Avoid Reserved Words:** Do not use SQL reserved words as object names.

### Table Naming Conventions

**Bronze Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- Pattern: `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the source system.
  - Example: `crm_customer_info` → Customer information from the CRM system.

**Silver Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- Pattern: `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the source system.
  - Example: `crm_customer_info` → Customer information from the CRM system.

**Gold Rules**
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- Pattern: `<category>_<entity>`
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).
  - Examples:
    - `dim_customers` → Dimension table for customer data.
    - `fact_sales` → Fact table containing sales transactions.

**Glossary of Category Patterns**

| Pattern | Meaning | Example(s) |
|---------|---------|------------|
| `dim_` | Dimension table | `dim_customer`, `dim_product` |
| `fact_` | Fact table | `fact_sales` |
| `agg_` | Aggregated table | `agg_customers`, `agg_sales_monthly` |

### Column Naming Conventions

**Surrogate Keys**
- All primary keys in dimension tables must use the suffix `_key`.
- Pattern: `<table_name>_key`
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.
  - `_key`: A suffix indicating that this column is a surrogate key.
  - Example: `customer_key` → Surrogate key in the `dim_customers` table.

**Technical Columns**
- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- Pattern: `dwh_<column_name>`
  - `dwh`: Prefix exclusively for system-generated metadata.
  - `<column_name>`: Descriptive name indicating the column's purpose.
  - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.

### Stored Procedure Naming Conventions

- All stored procedures used for loading data must follow the naming pattern: `load_<layer>`.
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Examples:
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
    - `load_gold` → Stored procedure for loading data into the Gold layer.

---

## Getting Started

### Prerequisites
- A relational database engine (e.g., SQL Server, PostgreSQL, Snowflake)
- An ETL tool or scripting language for orchestrating the pipeline (e.g., Python, SQL scripts, dbt)
- Access credentials for the source systems being extracted from

### Setup

1. Configure database connection settings for your environment.
2. Verify access credentials for each source system.
3. Run the full pipeline to populate the Bronze, Silver, and Gold layers in sequence.

---

## ETL Workflow

1. **Extract** — Full extraction of all records from each source system
2. **Load (Bronze)** — Truncate and insert raw data into Bronze tables
3. **Transform (Silver)** — Clean, standardize, and conform data; truncate and insert into Silver tables
4. **Model (Gold)** — Apply SCD Type 1 logic and build dimensional/fact tables via truncate-and-insert
5. **Validate** — Run data quality checks to confirm row counts, null checks, and key integrity

---

## Data Model

The Gold layer follows a **star schema** design:

- **Fact tables** — transactional/measurable events (e.g., sales, orders)
- **Dimension tables** (SCD Type 1) — descriptive context (e.g., customers, products, dates)

---

## Tech Stack

- **Database:** e.g., SQL Server, PostgreSQL, Snowflake
- **Orchestration/Scripting:** e.g., Python, SQL Stored Procedures, Airflow
- **Version Control:** Git

---

## Contributing

Contributions are welcome. Please open an issue to discuss proposed changes before submitting a pull request.

---

## License

This project is licensed under the MIT License.
