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
