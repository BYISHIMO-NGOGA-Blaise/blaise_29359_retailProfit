# Phase 0 — Research Log

**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Student:** BYISHIMO NGOGA Blaise — 29359  
**Date:** 6 November 2026

## Proposed project

**Title:** Smart Business Management & Digital Commerce Platform: Order Fulfillment and Inventory Control

**Short name:** SmartCommerce

**Problem statement:** Online retailers process orders, stock, cancellations, and deliveries across spreadsheets, marketplaces, and disconnected sales channels. When stock and order records are not updated together, businesses oversell products, dispatch orders late, lose track of returns, and report inaccurate stock. SmartCommerce will be an Oracle database with PL/SQL rules that record customers, products, orders, order lines, inventory, stock movements, shipments, and returns; check and reserve stock before an order is confirmed; block overselling; restore stock when an order is cancelled or a product is returned; and keep an auditable trail of every stock change.

**Planned innovation:** A database-level stock reservation and return reconciliation engine with an audit trail, plus an interactive Power BI dashboard connected live to Oracle views. The dashboard will show order volume, revenue, stock health, fulfillment status, return rates, and product/country performance.

## Research log

| # | Source (APA) | Type | Link | Key finding | Gap it shows |
|---|---|---|---|---|---|
| 1 | Chen, D., Sain, S. L., & Guo, K. (2012). Data mining for the online retail industry: A case study of RFM model-based customer segmentation using data mining. *Journal of Database Marketing & Customer Strategy Management, 19*(3), 197–208. | Research paper | https://doi.org/10.1057/dbm.2012.17 | Uses the same UK online retail transaction data to segment customers with RFM, k-means clustering, and decision-tree induction. The study shows that small online retailers often lack the customer-centric business intelligence needed to use their transaction data effectively. | The focus is customer segmentation and marketing, not operational order fulfillment, stock reservation, return reconciliation, or database-level inventory rules. |
| 2 | Raman, A., DeHoratius, N., & Ton, Z. (2001). Execution: The missing link in retail operations. *California Management Review, 43*(3), 136–152. | Research paper | https://doi.org/10.2307/41166093 | In one leading retailer, 65% of inventory records were inaccurate; at another, misplaced stock prevented one in six customers from finding products that were available. These execution problems reduced profits by more than 10%. | The paper is a managerial study of inventory record inaccuracy. It does not provide a database-level mechanism that reserves stock, prevents overselling, or audits every stock movement. |
| 3 | Hübner, A., Kuhn, H., & Wollenburg, J. (2016). Last mile fulfilment and distribution in omni-channel grocery retailing: A strategic planning framework. *International Journal of Retail & Distribution Management, 44*(3), 228–247. | Research paper | https://doi.org/10.1108/IJRDM-11-2014-0154 | Omni-channel fulfilment requires integrated back-end fulfilment (warehouse and in-store picking) and last-mile distribution. The authors develop a planning framework that links order fulfilment design choices to retailer capabilities and customer behaviour. | The framework is strategic and grocery-specific. It does not implement an operational order, inventory, shipment, and returns database for a small digital retailer. |
| 4 | UNCTAD. (2021). *Estimates of global e-commerce 2019 and preliminary assessment of COVID-19 impact on online retail 2020* (UNCTAD Technical Notes on ICT for Development No. 18). | Report / statistic | https://unctad.org/system/files/official-document/tn_unctad_ict4d18_en.pdf | Global e-commerce sales reached about $26.7 trillion in 2019, including $4.9 trillion in B2C sales. Online retail’s share of total retail sales rose from 16% to 19% in 2020, and about 1.48 billion people shopped online in 2019. | The report measures the scale of e-commerce but does not address how a small retailer should control stock, orders, cancellations, and returns in an operational database. |
| 5 | World Bank. (2024). *Digital progress and trends report 2023*. | Report / statistic | https://www.worldbank.org/en/publication/digital-progress-and-trends-report | Business digitalization is uneven. Between April 2020 and December 2022, the share of micro firms investing in digital solutions doubled from 10% to 20%, while large firms rose from 20% to 60%. Many small and medium enterprises in lower-income countries still lack a computer or internet connection. | The report shows a digital divide but does not provide an affordable, inspectable order and inventory system that small retailers can adapt. |
| 6 | Shopify. (n.d.). *Shopify: Ecommerce platform*. | Existing system | https://www.shopify.com/ | Shopify provides online storefronts, order management, inventory tracking, fulfillment, returns, and analytics in one commercial platform. | It is a proprietary subscription platform. Public materials do not expose a small, open, database-level PL/SQL rule layer that a small retailer or a student project can inspect, adapt, and audit. |
| 7 | Chen, D. (2012). *Online Retail II* [Data set]. UCI Machine Learning Repository. | Dataset | https://doi.org/10.24432/C5CG6D | 1,067,371 transaction lines and 8 columns from a UK-based online retailer, covering 1 December 2009 to 9 December 2011. The data includes 53,628 invoices, 5,942 customers, 5,304 stock codes, and 43 countries. Licensed CC BY 4.0. | The dataset has no opening stock, supplier purchase records, cost prices, shipment dates, order status, or sales channel. Orders and returns must be derived from invoices and negative quantities, and opening inventory and shipment status must be documented workflow or simulation values. |
| 8 | Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. | Technical source | https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html | Oracle triggers are stored PL/SQL units that fire automatically on specified DML events. They can enforce complex business rules and security checks inside the database. | Not a gap: this is the technical basis. The project will use triggers to validate order lines, update inventory after stock movements, enforce status transitions, and write audit records. |

## Source mix check

| Required source type | Covered by |
|---|---|
| Research papers (at least 2) | Sources 1, 2, 3 |
| Report or statistic (at least 1) | Sources 4, 5 |
| Existing system (at least 1) | Source 6 |
| Dataset (at least 1) | Source 7 |
| Technical source (at least 1) | Source 8 |
| **Total** | **8 credible sources** |

## Dataset audit note

I downloaded and inspected the UCI Online Retail II dataset on 6 November 2026. The file is `online_retail_II.xlsx` and contains two sheets: `Year 2009-2010` and `Year 2010-2011`.

- **Size:** 1,067,371 data rows × 8 columns (45.6 MB); 525,461 rows in the first sheet and 541,910 in the second.
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Period:** 1 December 2009 to 9 December 2011.
- **Coverage:** 53,628 unique invoices, 5,942 customers, 5,304 stock codes, and 43 countries.
- **Revenue:** about £19,287,250.57 gross, calculated as `Quantity × Price` and including cancellations. Cancellation lines account for about -£1,526,667.86.
- **Missing values:** `Customer ID` is missing on 243,007 lines (22.8%); `Description` is missing on 4,382 lines.
- **Cancellations and returns:** 22,950 lines have a negative quantity. There are 8,292 cancellation invoices (19,494 lines) whose invoice numbers begin with `C`. These will be preserved as return records instead of being deleted.
- **Price quality:** 6,202 lines have a zero price and 5 lines have a negative price. These will be flagged and excluded from revenue calculations.
- **Non-product lines:** stock codes such as `POST`, `DOT`, `M`, `BANK CHARGES`, and `AMAZONFEE` are postage, adjustment, or service lines. They will be excluded from product-level inventory analysis.
- **Privacy:** the dataset is anonymised. There are no names, addresses, phone numbers, or national ID numbers.
- **Limitations:** the source has no opening stock, supplier purchase records, cost prices, shipment dates, order status, or sales channel. In Phase II I will derive orders from invoices, order lines from transaction rows, and returns from cancellations/negative quantities. Opening inventory, shipment status, and channel will be documented workflow fields or simulation values, not claims about the source data.

## Search trail

The sources above were found through Google Scholar and general web search, then verified by opening the source pages or PDFs:

- `online retail order fulfillment inventory research paper`
- `retail inventory record inaccuracy Raman DeHoratius Ton`
- `omni-channel last mile fulfilment Hübner Kuhn Wollenburg`
- `UNCTAD global e-commerce estimates 2019 online retail 2020`
- `World Bank Digital Progress and Trends Report 2023 business digitalization`
- `UCI Online Retail II dataset 502`
- `Shopify order management inventory fulfillment returns`
- `Oracle Database 19c Using Triggers documentation`

## Problem justification (synthesis)

The evidence points to a practical gap. E-commerce is large and still growing, and small retailers are digitising, but many still run orders, stock, cancellations, and returns on spreadsheets or disconnected tools. Research shows that inventory records are often inaccurate and that omni-channel fulfilment is complex. Commercial platforms such as Shopify solve parts of the problem, but they are proprietary subscription products and do not expose a small, open, database-level rule layer that a small retailer or a student project can inspect and adapt.

SmartCommerce addresses that gap with Oracle PL/SQL. Before an order is confirmed, the system checks available stock, reserves the required quantity, and blocks the confirmation if any line cannot be fulfilled. Cancellations release reservations; approved returns restore stock only when the item is marked for restocking. Every movement is written to `stock_movements` and `audit_log`, so the business can trace why stock changed. A live Power BI dashboard adds operational visibility. The word “smart” in this project refers to rule-based automation and alerts, not machine learning.

## Full APA references

Chen, D. (2012). *Online Retail II* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

Chen, D., Sain, S. L., & Guo, K. (2012). Data mining for the online retail industry: A case study of RFM model-based customer segmentation using data mining. *Journal of Database Marketing & Customer Strategy Management, 19*(3), 197–208. https://doi.org/10.1057/dbm.2012.17

Hübner, A., Kuhn, H., & Wollenburg, J. (2016). Last mile fulfilment and distribution in omni-channel grocery retailing: A strategic planning framework. *International Journal of Retail & Distribution Management, 44*(3), 228–247. https://doi.org/10.1108/IJRDM-11-2014-0154

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

Raman, A., DeHoratius, N., & Ton, Z. (2001). Execution: The missing link in retail operations. *California Management Review, 43*(3), 136–152. https://doi.org/10.2307/41166093

Shopify. (n.d.). *Shopify: Ecommerce platform*. https://www.shopify.com/

UNCTAD. (2021). *Estimates of global e-commerce 2019 and preliminary assessment of COVID-19 impact on online retail 2020* (UNCTAD Technical Notes on ICT for Development No. 18). https://unctad.org/system/files/official-document/tn_unctad_ict4d18_en.pdf

World Bank. (2024). *Digital progress and trends report 2023*. https://www.worldbank.org/en/publication/digital-progress-and-trends-report
