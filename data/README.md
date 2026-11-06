# Data

## Source

- **Dataset:** Online Retail II
- **Author:** Daqing Chen (2012)
- **Repository:** UCI Machine Learning Repository
- **URL:** https://doi.org/10.24432/C5CG6D
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **File:** `online_retail_II.xlsx`
- **Sheets:** `Year 2009-2010`, `Year 2010-2011`
- **Rows:** 1,067,371 transaction lines
- **Columns:** 8
- **Period:** 1 December 2009 – 9 December 2011
- **Size:** 45.6 MB

## Audit summary

- 525,461 lines in `Year 2009-2010` and 541,910 lines in `Year 2010-2011`.
- 53,628 unique invoices, 5,942 customers, 5,304 stock codes, and 43 countries.
- Gross revenue is about £19,287,250.57, calculated as `Quantity × Price` and including cancellations. Cancellation lines account for about -£1,526,667.86.
- `Customer ID` is missing on 243,007 lines (22.8%); `Description` is missing on 4,382 lines.
- 22,950 lines have a negative quantity.
- 8,292 invoices (19,494 lines) are cancellation invoices whose numbers begin with `C`.
- 6,202 lines have a zero price and 5 lines have a negative price.
- No names, addresses, phone numbers, or national ID numbers are present.

## Cleaning plan for Phase II

1. Keep negative quantities and `C` invoices as return records; do not delete them as bad data.
2. Exclude postage, adjustment, and service codes such as `POST`, `DOT`, `M`, `BANK CHARGES`, and `AMAZONFEE` from product-level inventory analysis.
3. Treat missing `Customer ID` values as guest or unidentified orders and exclude them from customer-level analysis.
4. Flag zero and negative prices; exclude them from revenue calculations.
5. Review missing descriptions against the product code.
6. Derive orders from invoices and order lines from transaction rows.
7. Create opening inventory and shipment status as documented workflow or simulation values. They are not present in the source data.

## Important limitation

The dataset has no opening stock, supplier purchase records, cost prices, shipment dates, order status, or sales channel. In Phase II, orders will be derived from invoices, order lines from transaction rows, and returns from cancellations/negative quantities. Opening inventory, shipment status, and channel will be documented workflow fields or simulation values, not claims about the source data.

## Attribution

Chen, D. (2012). *Online Retail II* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

The dataset is used for educational purposes under CC BY 4.0. Any transformed tables created in later phases will be documented in the `sql/` folder.
