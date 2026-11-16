# Phase II: five-minute class walkthrough

## Before presenting

Open these files in advance:

1. `data/raw/SuperMarket Analysis.csv`
2. `data/dataset_card.md`
3. `docs/design/normalization.md`
4. `docs/design/erd.png`
5. `docs/design/data_dictionary.md`

The IDs below are illustrative logical keys used in the design examples; they are not IDs supplied by the CSV.

## Timed walkthrough

### 0:00–0:45 — Show the raw data

Open `data/raw/SuperMarket Analysis.csv` and point to one row:

> “This is the original, unchanged Kaggle CSV. It contains 1,000 records and 17 columns. One row represents one invoice transaction and its recorded product-line category and measures. The invoice ID is unique in this file.”

Use invoice `750-67-8428` as the example. Point out the repeated descriptive values such as branch, city, customer type, payment method, and product line.

### 0:45–1:20 — Show the dataset card and quality results

Open `data/dataset_card.md` and explain:

> “The card records the dataset source, Apache 2.0 license, CSV format, size, collection date, and what one row represents. We checked the raw data without cleaning it: there are no missing cells or duplicate invoice IDs, three branches, three cities, two customer types, three payment methods, and six product lines. The margin percentage has the same value in every row.”

Mention that numeric-looking values and dates/times are text in the CSV and will be converted during the database loading phase. The raw copy remains unchanged.

### 1:20–2:00 — Explain UNF and 1NF

Open `docs/design/normalization.md`.

> “The UNF section shows the source as one wide relation, mixing transaction measures and repeated descriptions. The source has no repeating item columns or nested lists, and each field is already scalar. Therefore 1NF does not require splitting a repeating group: we identify the invoice ID as the row key and keep one row per invoice.”

Point out that three actual records are shown for comparison.

### 2:00–2:35 — Explain 2NF

> “The 1NF relation has one candidate key, `sale_id`, which is a single column. A partial dependency can only occur when a key is composite, so this relation is already in 2NF. We keep one table at this stage instead of claiming a partial dependency that the data does not have. Repeated values alone are not a 2NF violation.”

### 2:35–3:35 — Explain 3NF and trace one record

> “The source shows that each branch maps to a city, so branch determines city. We separate city from branch to remove that transitive dependency. We also use lookup tables for repeated customer-type, payment-method, and product-line labels.”

Trace invoice `750-67-8428` through the example rows:

| Source value | 3NF destination |
|---|---|
| Invoice `750-67-8428`, date/time, rating, gender | `SALE` |
| Branch `Alex` / city `Yangon` | `BRANCH` referencing `CITY`; `SALE.branch_id` references that branch |
| Customer type `Member` | `CUSTOMER_TYPE`; `SALE.customer_type_id` references it |
| Payment `Ewallet` | `PAYMENT_METHOD`; `SALE.payment_method_id` references it |
| Product line `Health and beauty` | `PRODUCT_LINE`; `SALE_LINE.product_line_id` references it |
| Price, quantity, tax, sales, COGS, gross income | `SALE_LINE` |

> “The source has no customer ID, so we do not create a customer table that suggests we can identify people. It also has one source row per invoice, so the current load creates one sale line per sale; the separate child table can support multiple lines if a future dataset provides them.”

### 3:35–4:25 — Show the ERD and table structures

Open `docs/design/erd.png`, then `docs/design/data_dictionary.md`.

> “The ERD shows the eight logical tables, their primary and foreign keys, and their one-to-many relationships. The dictionary defines every column, its meaning, whether it is required or unique, and relationship optionality. Oracle-specific types and sizes are intentionally deferred to the physical database phase.”

Briefly name the tables: `CITY`, `BRANCH`, `CUSTOMER_TYPE`, `PAYMENT_METHOD`, `PRODUCT_LINE`, `SALE`, and `SALE_LINE`.

### 4:25–5:00 — Close with scope and next step

> “The source margin percentage is constant and derived, so we keep it in the raw file for traceability but do not store it in the normalized tables. The logical schema is the blueprint for the next database phase, where we will convert text dates and numbers, create the Oracle tables and constraints, and load validated data.”

## Quick answers if asked

- **Why is 2NF one table?** The only candidate key is a single-column invoice ID, so there can be no partial dependency.
- **Why split branch and city?** The source maps each branch to one city, so separating city removes repeated city values and the branch-to-city transitive dependency.
- **Why no `CUSTOMER` table?** The source has customer segment and gender but no identifier for individual customers.
- **Why keep `SALE_LINE` if each invoice has one row here?** It keeps product-category and financial line measures separate and supports a future source with multiple lines per invoice; the current source itself does not demonstrate that case.
- **Why not store gross margin percentage?** It is the same derived value in every source row; it can be calculated for reports instead of storing a redundant constant.
