# Banking Data Pipeline

This project demonstrates the design and implementation of a complete data pipeline for a fictional banking system. It includes data loading, transformation, modeling, and dashboard creation using PostgreSQL, Airflow, dbt, and Superset.

## Project Objectives

- Load raw banking data into PostgreSQL
- Transform and model data using dbt
- Build mart tables
- Create interactive dashboards for business insights

## Tools and Technologies

- **PostgreSQL** – Relational database for raw and processed data
- **Apache Airflow** – Pipeline orchestration and scheduling
- **dbt (Data Build Tool)** – SQL-based data transformation and modeling
- **Apache Superset** – Data visualization and dashboarding
- **Docker** – Containerization for environment setup


## Pipeline Overview

1. **Data Loading** – Raw CSV files are loaded into PostgreSQL using SQL scripts and Airflow DAGs
2. **Transformation & Modeling** – dbt builds:
   - Staging views for cleaned data
   - Mart tables for analytics
3. **Visualization** – Superset connects to the modeled data for interactive dashboarding

## Superset Dashboards

Dashboards include insights such as:

- Customer activity and spending trends
- Product-wise revenue and usage
- Card transaction behavior over time



