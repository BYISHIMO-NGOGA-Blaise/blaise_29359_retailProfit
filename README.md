# SmartCommerce — Smart Business Management & Digital Commerce Platform

**Order Fulfillment and Inventory Control**

**Student:** BYISHIMO NGOGA Blaise — **29359**  
**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Academic year:** 2026–2027, Semester I  
**Phase:** 0 — Research, data source, and project proposal

## Problem statement

Online retailers process orders, stock, cancellations, and deliveries across spreadsheets, marketplaces, and disconnected sales channels. When stock and order records are not updated together, businesses oversell products, dispatch orders late, lose track of returns, and report inaccurate stock. SmartCommerce will be an Oracle database with PL/SQL rules that record customers, products, orders, order lines, inventory, stock movements, shipments, and returns; check and reserve stock before an order is confirmed; block overselling; restore stock when an order is cancelled or a product is returned; and keep an auditable trail of every stock change.

## Objectives

**Main objective:** Design and implement an Oracle database with PL/SQL that controls order fulfillment and inventory for a digital commerce business.

**Specific objectives:**

1. Model customers, products, orders, order lines, inventory, stock movements, shipments, returns, return lines, and audit events in third normal form (3NF).
2. Load and validate the UCI Online Retail II dataset, remove non-product adjustment lines, preserve cancellations as returns, handle missing customer IDs, and derive orders, order lines, and returns.
3. Develop PL/SQL functions, procedures, cursors, packages, and triggers that check available stock, reserve stock, prevent overselling, calculate order totals, process cancellations and returns, restore stock, and write audit records.
4. Build a live Power BI dashboard connected to Oracle views that shows order volume, revenue, stock health, fulfillment status, return rates, and product/country performance.
5. Document the system and demonstrate it live in the final presentation.

## Data source

- **Dataset:** *Online Retail II*
- **Author:** Daqing Chen (2012)
- **Repository:** UCI Machine Learning Repository — https://doi.org/10.24432/C5CG6D
- **File used:** `online_retail_II.xlsx` (sheets: `Year 2009-2010` and `Year 2010-2011`)
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Size:** 1,067,371 transaction lines × 8 columns (45.6 MB)
- **Period:** 1 December 2009 – 9 December 2011
- **Coverage:** 53,628 invoices, 5,942 customers, 5,304 stock codes, 43 countries
- **Revenue:** about £19.29 million gross across both years, including cancellations
- **Key fields:** `Invoice`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `Price`, `Customer ID`, `Country`
- **Privacy:** the data is anonymised; there are no names, addresses, phone numbers, or national ID numbers
- **Local copy:** `data/online_retail_II.xlsx`

### Audit findings

- 525,461 lines in `Year 2009-2010` and 541,910 lines in `Year 2010-2011`.
- 243,007 lines (22.8%) have no `Customer ID`; these will be treated as guest or unidentified orders and excluded from customer-level analysis.
- 4,382 lines have no `Description`; these will be reviewed during cleaning.
- 22,950 lines have a negative quantity; 8,292 invoices (19,494 lines) are cancellation invoices whose numbers begin with `C`. These will become return records, not deleted sales.
- 6,202 lines have a zero price and 5 lines have a negative price; these will be flagged and excluded from revenue calculations.
- Codes such as `POST`, `DOT`, `M`, `BANK CHARGES`, and `AMAZONFEE` are postage, adjustment, or service lines, not physical products. They will be excluded from product-level inventory analysis.
- The dataset has no opening stock, supplier purchase records, cost prices, shipment dates, order status, or sales channel. In Phase II, orders will be derived from invoices, order lines from transaction rows, and returns from cancellations/negative quantities. Opening inventory, shipment status, and channel will be documented workflow fields or simulation values, not claims about the source data.

## Innovation

**Option:** Analytics dashboard with a database-level rule engine  
**Tool:** Power BI, connected live to the Oracle database.

The main innovation is a **stock reservation and return reconciliation engine** inside Oracle PL/SQL. Before an order is confirmed, the system checks available stock (`quantity_on_hand - quantity_reserved`), reserves the required quantity, and blocks the confirmation if any line cannot be fulfilled. Cancellations release reservations; returns restore stock only when the returned item is marked for restocking. Every movement is written to `stock_movements` and `audit_log`, so the business can trace why stock changed.

Power BI will read Oracle views backed by PL/SQL and show:

- order volume, revenue, and average order value over time;
- stock on hand, reserved stock, available stock, and low-stock products;
- orders by fulfillment status and dispatch delay;
- return rate by product, customer, and country;
- top products and countries by revenue;
- stock exceptions, blocked confirmations, and audit events.

Business rules remain in PL/SQL; Power BI only displays and filters the results.

## Planned database tables

| Table | Purpose |
|---|---|
| `customers` | Anonymised customer identifier, country, first order date, and derived segment. |
| `products` | Product stock code, description, current unit price, product type, and active status. |
| `orders` | Invoice/order header, customer, order date, channel, status, and total amount. |
| `order_lines` | Product, quantity, unit price, line total, and line status for each order. |
| `inventory` | Quantity on hand, quantity reserved, reorder level, and last update per product. |
| `stock_movements` | Every opening, sale, return, reservation, release, and adjustment movement. |
| `shipments` | Carrier, dispatch date, delivery date, tracking number, and shipment status. |
| `returns` | Return header linked to an order, return date, reason, status, and refund amount. |
| `return_lines` | Returned product, quantity, condition, and restock decision. |
| `audit_log` | Every critical insert, update, status change, and stock adjustment with user, timestamp, and reason. |
| `order_status_history` | Chronological status changes for each order. |
| `channels` | Lookup table for online, phone, marketplace, and wholesale channels. |

### Key relationships

- One `customer` has many `orders`.
- One `order` has many `order_lines` and one or more `shipments`.
- One `product` has one `inventory` record and many `stock_movements`.
- One `order` can have many `returns`, and one `return` has many `return_lines`.
- One `order_line` can be referenced by one or more `return_lines`.
- `order_status_history` and `audit_log` record changes over time.

## Planned PL/SQL features

| Feature | Planned use |
|---|---|
| Function `fn_available_stock` | Returns `quantity_on_hand - quantity_reserved` for a product. |
| Function `fn_order_total` | Calculates an order total from its order lines. |
| Procedure `prc_add_order_line` | Validates product, quantity, and price; inserts a line; updates the order total. |
| Procedure `prc_confirm_order` | Checks and reserves stock for every line; blocks the order if stock is insufficient. |
| Procedure `prc_cancel_order` | Releases reservations and restores stock when an order is cancelled before dispatch. |
| Procedure `prc_process_return` | Validates the return quantity, records the return, and restocks the product when approved. |
| Procedure `prc_adjust_stock` | Records cycle-count or damage adjustments with a mandatory reason. |
| Cursor `cur_low_stock_products` | Lists products at or below their reorder level. |
| Cursor `cur_high_return_products` | Lists products whose return rate exceeds a configurable threshold. |
| Package `pkg_smartcommerce` | Groups order, inventory, shipment, and return logic. |
| Trigger `trg_order_line_bi` | Validates quantity and price and calculates the line total before insert. |
| Trigger `trg_stock_movement_ai` | Updates `inventory.quantity_on_hand` after each stock movement. |
| Trigger `trg_order_status_biu` | Enforces valid order status transitions and writes status history. |
| Trigger `trg_audit_stock` | Writes an audit record for every stock and order-status change. |
| Views `vw_order_fulfillment`, `vw_stock_health`, `vw_product_performance`, `vw_return_summary`, `vw_country_sales` | Feed the Power BI dashboard. |
| Exception handling | Custom errors for insufficient stock, invalid return quantity, invalid status transition, and inactive product. |
| Scheduler job | Releases expired reservations and refreshes summary views nightly. |

## Repository structure

```
.
├── README.md
├── data/
│   ├── README.md
│   └── online_retail_II.xlsx
├── docs/
│   ├── proposal/
│   │   └── registration_row.md
│   ├── research/
│   │   └── research_log.md
│   └── presentation/
└── (later phases: sql/, innovation/, screenshots/)
```

## Phase 0 checklist

- [x] Topic selected in the business and digital commerce area.
- [x] At least 6 credible sources, including a dataset.
- [x] Real dataset downloaded and audited.
- [ ] Topic registered on the instructor's Google Sheet.
- [x] GitHub repository created and named correctly.
- [ ] Proposal emailed to the instructor with the GitHub link.
- [ ] Presentation uploaded to the repository.

## References

Chen, D. (2012). *Online Retail II* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

Chen, D., Sain, S. L., & Guo, K. (2012). Data mining for the online retail industry: A case study of RFM model-based customer segmentation using data mining. *Journal of Database Marketing & Customer Strategy Management, 19*(3), 197–208. https://doi.org/10.1057/dbm.2012.17

Hübner, A., Kuhn, H., & Wollenburg, J. (2016). Last mile fulfilment and distribution in omni-channel grocery retailing: A strategic planning framework. *International Journal of Retail & Distribution Management, 44*(3), 228–247. https://doi.org/10.1108/IJRDM-11-2014-0154

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

Raman, A., DeHoratius, N., & Ton, Z. (2001). Execution: The missing link in retail operations. *California Management Review, 43*(3), 136–152. https://doi.org/10.2307/41166093

Shopify. (n.d.). *Shopify: Ecommerce platform*. https://www.shopify.com/

UNCTAD. (2021). *Estimates of global e-commerce 2019 and preliminary assessment of COVID-19 impact on online retail 2020* (UNCTAD Technical Notes on ICT for Development No. 18). https://unctad.org/system/files/official-document/tn_unctad_ict4d18_en.pdf

World Bank. (2024). *Digital progress and trends report 2023*. https://www.worldbank.org/en/publication/digital-progress-and-trends-report
