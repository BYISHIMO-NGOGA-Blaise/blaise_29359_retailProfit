# Retail Sales and Profitability Monitoring System

**Course:** INSY 8311 — Database Development with PL/SQL
**Student:** Blaise Byishimo Ngoga
**Student ID:** 29359
**Database:** Oracle Database 21c
**Planned innovation:** Power BI dashboard connected to Oracle

## Project overview

This project will build an Oracle database solution for monitoring retail sales and gross profitability. It will analyze sales and gross income by branch, product line, and date, helping managers compare performance.

The project uses the public Supermarket Sales dataset from Kaggle. It contains transaction-level fields such as branch, product line, quantity, unit price, cost of goods sold, total, and gross income. The dataset is small and suitable for a course project. It does not contain stock-on-hand or discount fields, so inventory control and discount-impact analysis are outside the current scope.

## Objectives

- Organize the source transactions into a normalized Oracle schema.
- Validate and load the data, then calculate and report sales and gross-profit measures.
- Use PL/SQL to enforce transaction rules and support reporting.
- Connect Power BI to Oracle 21c for interactive analysis by branch, product line, and date.

## Data source

Fares Ashraf's [Supermarket Sales Dataset on Kaggle](https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales) (Version 2; Apache 2.0 license). Kaggle sign-in may be required to download it. See [data/README.md](data/README.md) for handling instructions.

## Planned database objects

- `BRANCH`
- `PRODUCT_LINE`
- `CUSTOMER_TYPE`
- `PAYMENT_METHOD`
- `SALE`
- `SALE_LINE`
- `AUDIT_LOG`

Final table definitions will be based on the downloaded source file and the normalization work in Phase II.

## Planned PL/SQL features

- Procedures to load validated sales and generate profitability summaries.
- Functions to calculate or validate gross-profit measures.
- A package for sales processing and reporting.
- Triggers and constraints to reject invalid quantities or prices, prevent duplicate invoices, and record relevant changes.
- Cursors and exception handling in batch processing and reporting.

## Innovation

An interactive Power BI dashboard will connect to Oracle 21c and present sales trends, branch performance, product-line gross income, and gross-margin summaries. The dashboard will use live database data; PL/SQL will enforce the business rules.

## Phase 0 documents

- [Proposal](docs/proposal/phase0_proposal.md)
- [Registration description](docs/proposal/registration_row.md)
- [Research log](docs/research/research_log.md)
- [Presentation outline](docs/presentation/README.md)

## References

See the [research log](docs/research/research_log.md) for the sources reviewed and the project-specific findings and gaps.

Before registering, compare the proposed topic against entries in all four group tabs of the registration sheet and confirm the automatic check says OK.
