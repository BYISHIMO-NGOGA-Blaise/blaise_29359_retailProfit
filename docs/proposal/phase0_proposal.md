# Retail Sales and Profitability Monitoring System

**Student:** Blaise Byishimo Ngoga
**Student ID:** 29359
**Course:** INSY 8311 — Database Development with PL/SQL
**Database:** Oracle Database 21c

## Problem statement

Retail managers need timely information to compare sales and profitability across branches, product lines, and time periods. When transaction data is not organized for analysis, managers may overlook weak product-line performance and make decisions without clear evidence of gross income and cost of goods sold. This project will develop a database-based monitoring solution to make those measures easier to validate and review.

## Proposed solution

The system will store supermarket sales transactions in a normalized Oracle schema. Data validation and PL/SQL routines will support accurate transaction processing and profitability summaries. Power BI will connect to Oracle 21c and provide interactive views of sales and gross income by branch, product line, and date.

## Data source

The project will use Fares Ashraf's *Supermarket Sales Dataset* (Version 2) from Kaggle. The dataset is a compact transaction-level sample with fields including branch, product line, quantity, unit price, total, cost of goods sold, and gross income. The Kaggle listing identifies the license as Apache 2.0. Source link and handling notes are in [data/README.md](../../data/README.md).

## Planned tables

`BRANCH`, `PRODUCT_LINE`, `CUSTOMER_TYPE`, and `PAYMENT_METHOD` will hold repeated descriptive values. `SALE` will hold invoice-level data, while `SALE_LINE` will hold product and financial measures. `AUDIT_LOG` will record selected data changes. The final design will follow the Phase II normalization and data dictionary.

## Planned PL/SQL features

Procedures will support validated loading and profitability reporting. Functions will calculate or validate gross-profit measures. A package will group sales-processing and reporting operations. Constraints and triggers will reject invalid quantities or prices, prevent duplicate invoices, and record relevant changes. Cursors and exceptions will be used in batch processing and error handling.

## Innovation

An interactive Power BI dashboard connected to Oracle 21c will display sales trends and gross-income comparisons by branch, product line, and date. The database and PL/SQL routines will remain responsible for data and business rules; Power BI will provide the interactive presentation layer.

## Scope limitation

The selected dataset does not provide stock-on-hand or explicit discount values, and its gross-margin-percentage field is fixed. Therefore, the project will focus on gross-income amounts and will not claim to implement inventory control, measure discount impact, or compare varying margins without additional data.

## References (APA)

Ashraf, F. (2024). *Supermarket sales dataset* (Version 2) [Data set]. Kaggle. https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales

Gaur, V., Fisher, M. L., & Raman, A. (2005). An econometric analysis of inventory turnover performance in retail services. *Management Science, 51*(2), 181–194. https://doi.org/10.1287/mnsc.1040.0298

Grewal, D., Roggeveen, A. L., & Nordfält, J. (2017). The future of retailing. *Journal of Retailing, 93*(1), 1–6. https://doi.org/10.1016/j.jretai.2016.12.008

Microsoft. (n.d.). *Power Query Oracle database connector*. Microsoft Learn. https://learn.microsoft.com/en-us/power-query/connectors/oracle-database

Oracle. (2024). *Database PL/SQL language reference* (21c). https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/index.html

Shopify. (n.d.). *Shopify analytics*. Shopify Help Center. https://help.shopify.com/en/manual/reports-and-analytics/shopify-reports

U.S. Census Bureau. (n.d.). *Retail trade surveys*. https://www.census.gov/retail/index.html
