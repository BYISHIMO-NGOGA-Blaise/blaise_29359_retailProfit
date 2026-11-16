# Phase II: normalization and logical design

## 1. Dataset and row meaning

The source is `data/raw/SuperMarket Analysis.csv`: 1,000 records and 17 fields. One source record represents one transaction/invoice and its one recorded product-line category and financial measures. The invoice ID is unique in this file. The source does not identify individual products or customers, and this design does not invent either identifier.

The seven-table logical design below separates transaction data from repeated reference values, and separates branch from city because the source shows that each branch maps to one city.

## 2. Unnormalized form (UNF): source as received

UNF here means the original wide CSV before the normalization checks. The values in each row are scalar and the source has no nested list or repeated item columns; therefore it is already close to 1NF. Its problem is that facts about sales, branches, cities, and categories are stored together and repeat across records.

| Invoice ID | Branch | City | Customer type | Gender | Product line | Unit price | Quantity | Tax 5% | Sales | Date | Time | Payment | COGS | Gross margin % | Gross income | Rating |
|---|---|---|---|---|---|---:|---:|---:|---:|---|---|---|---:|---:|---:|---:|
| 750-67-8428 | Alex | Yangon | Member | Female | Health and beauty | 74.69 | 7 | 26.1415 | 548.9715 | 1/5/2019 | 1:08:00 PM | Ewallet | 522.83 | 4.761904762 | 26.1415 | 9.1 |
| 226-31-3081 | Giza | Naypyitaw | Normal | Female | Electronic accessories | 15.28 | 5 | 3.82 | 80.22 | 3/8/2019 | 10:29:00 AM | Cash | 76.4 | 4.761904762 | 3.82 | 9.6 |
| 631-41-3108 | Alex | Yangon | Normal | Female | Home and lifestyle | 46.33 | 7 | 16.2155 | 340.5255 | 3/3/2019 | 1:23:00 PM | Credit card | 324.31 | 4.761904762 | 16.2155 | 7.4 |

**Issue at this stage:** the same branch, city, customer type, payment method, and product-line descriptions recur in the wide transaction records. For example, `Alex` and `Yangon` recur together.

## 3. First normal form (1NF)

**Rule:** each row is one record, each field has one atomic value, and each row has a key.

**Change made:** use `Invoice ID` as the row key (`sale_id`). The source already has one scalar value per field and one unique invoice per row, so no repeating group needs to be split. Date/time and numeric-looking values remain as supplied here; converting their text representation to database types is a Phase IV cleaning task.

### 1NF relation: `RAW_SALE`

`RAW_SALE(sale_id [PK], branch_name, city_name, customer_type_name, gender, product_line_name, unit_price, quantity, tax_amount, sales_amount, sale_date, sale_time, payment_method_name, cogs, gross_margin_pct, gross_income, rating)`

| sale_id (PK) | branch_name | city_name | customer_type_name | gender | product_line_name | unit_price | quantity | payment_method_name |
|---|---|---|---|---|---|---:|---:|---|
| 750-67-8428 | Alex | Yangon | Member | Female | Health and beauty | 74.69 | 7 | Ewallet |
| 226-31-3081 | Giza | Naypyitaw | Normal | Female | Electronic accessories | 15.28 | 5 | Cash |
| 631-41-3108 | Alex | Yangon | Normal | Female | Home and lifestyle | 46.33 | 7 | Credit card |

The remaining measures and date/time for these same rows are unchanged from the UNF sample above.

## 4. Second normal form (2NF)

**Rule:** the relation must be in 1NF, and every non-key attribute must depend on the whole candidate key; no non-key attribute may depend on only part of a composite key.

**Result for this dataset:** `RAW_SALE` is already in 2NF. Its only candidate key is the single-column `sale_id`, so a partial dependency on part of a composite key is impossible. No table split is made at this step. This is an important result of applying the rule to the actual data rather than claiming a partial dependency that is not present.

### 2NF relation (unchanged)

`RAW_SALE(sale_id [PK], branch_name, city_name, customer_type_name, gender, product_line_name, unit_price, quantity, tax_amount, sales_amount, sale_date, sale_time, payment_method_name, cogs, gross_margin_pct, gross_income, rating)`

| sale_id (PK) | branch_name | city_name | customer_type_name | product_line_name | unit_price | quantity | payment_method_name |
|---|---|---|---|---|---:|---:|---|
| 750-67-8428 | Alex | Yangon | Member | Health and beauty | 74.69 | 7 | Ewallet |
| 226-31-3081 | Giza | Naypyitaw | Normal | Electronic accessories | 15.28 | 5 | Cash |
| 631-41-3108 | Alex | Yangon | Normal | Home and lifestyle | 46.33 | 7 | Credit card |

These are three rows from the same 1NF relation; date/time, gender, tax, sales, COGS, gross income, margin, and rating also remain unchanged.

## 5. Third normal form (3NF)

**Rule:** the relation must be in 2NF, and non-key attributes must depend on the key, the whole key, and nothing but the key. A non-key attribute must not determine another non-key attribute.

### Dependencies identified in this source

- `sale_id` determines the values recorded for a transaction.
- `branch_name` determines `city_name` in this dataset: `Alex` maps to Yangon, `Cairo` to Mandalay, and `Giza` to Naypyitaw.
- Customer type, payment method, and product-line labels are repeated controlled values. They are represented by lookup tables so sales reference one canonical label instead of repeating it in transaction rows. This is a practical reference-data decomposition, not a claim that each label alone causes a transitive dependency.

### 3NF split and sample rows

**`CITY(city_id [PK], city_name [UNIQUE])`**

| city_id | city_name |
|---:|---|
| 1 | Yangon |
| 2 | Naypyitaw |
| 3 | Mandalay |

**`BRANCH(branch_id [PK], branch_name [UNIQUE], city_id [FK])`**

| branch_id | branch_name | city_id |
|---:|---|---:|
| 1 | Alex | 1 |
| 2 | Giza | 2 |
| 3 | Cairo | 3 |

**`CUSTOMER_TYPE(customer_type_id [PK], customer_type_name [UNIQUE])`**

| customer_type_id | customer_type_name |
|---:|---|
| 1 | Member |
| 2 | Normal |

**`PAYMENT_METHOD(payment_method_id [PK], payment_method_name [UNIQUE])`**

| payment_method_id | payment_method_name |
|---:|---|
| 1 | Cash |
| 2 | Credit card |
| 3 | Ewallet |

**`PRODUCT_LINE(product_line_id [PK], product_line_name [UNIQUE])`**

| product_line_id | product_line_name |
|---:|---|
| 1 | Electronic accessories |
| 2 | Fashion accessories |
| 3 | Food and beverages |

The remaining product-line values are `Health and beauty`, `Home and lifestyle`, and `Sports and travel`.

**`SALE(sale_id [PK], sale_date, sale_time, branch_id [FK], customer_type_id [FK], gender, payment_method_id [FK], rating)`**

| sale_id | sale_date | sale_time | branch_id | customer_type_id | gender | payment_method_id | rating |
|---|---|---|---:|---:|---|---:|---:|
| 750-67-8428 | 2019-01-05 | 13:08:00 | 1 | 1 | Female | 3 | 9.1 |
| 226-31-3081 | 2019-03-08 | 10:29:00 | 2 | 2 | Female | 1 | 9.6 |
| 631-41-3108 | 2019-03-03 | 13:23:00 | 1 | 2 | Female | 2 | 7.4 |

**`SALE_LINE(sale_line_id [PK], sale_id [FK], product_line_id [FK], unit_price, quantity, tax_amount, sales_amount, cogs, gross_income)`**

| sale_line_id | sale_id | product_line_id | unit_price | quantity | tax_amount | sales_amount | cogs | gross_income |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | 750-67-8428 | 4 | 74.69 | 7 | 26.1415 | 548.9715 | 522.83 | 26.1415 |
| 2 | 226-31-3081 | 1 | 15.28 | 5 | 3.82 | 80.22 | 76.4 | 3.82 |
| 3 | 631-41-3108 | 5 | 46.33 | 7 | 16.2155 | 340.5255 | 324.31 | 16.2155 |

### Why the 3NF split is useful

- `city_name` is stored once in `CITY`; `BRANCH.city_id` links a branch to its city. This removes the branch-to-city transitive dependency from the sale relation.
- Each sale references a branch, customer-type label, and payment-method label by key; each sale line references a product-line label by key. These lookup tables reduce repeated text and support consistent reporting.
- Customer type and gender remain attributes of `SALE`. The source has no customer ID, so a `CUSTOMER` entity would falsely imply that individual customers can be identified.
- The source has one row per invoice, so the current load produces one `SALE_LINE` per `SALE`. The separate child table keeps line-level measures and product-line category distinct and allows multiple lines if a future source provides them. The current source does not prove that invoices have multiple items.

**Dependency removed:** moving `city_name` from the sale record into `CITY`, keyed through `BRANCH`, removes the non-key-to-non-key dependency `branch_name -> city_name`. Lookup tables also centralize repeated category labels.

## 6. Logical table structure and relationships

The logical column definitions, meaning, required/unique status, primary keys, foreign keys, cardinalities, and optionality are listed in [data_dictionary.md](./data_dictionary.md). The crow's-foot overview is [erd.png](./erd.png).

## 7. Raw-field mapping and Phase IV cleaning checklist

| Raw field | 3NF target | Phase IV conversion or validation |
|---|---|---|
| `Invoice ID` | `SALE.sale_id` | Preserve as text key; confirm uniqueness |
| `Branch` | `BRANCH.branch_name`, resolved to `SALE.branch_id` | Map each source label to its branch key |
| `City` | `CITY.city_name`, referenced by `BRANCH.city_id` | Check branch-to-city mapping |
| `Customer type` | `CUSTOMER_TYPE.customer_type_name`, resolved to `SALE.customer_type_id` | Map to lookup key |
| `Gender` | `SALE.gender` | Validate controlled source values |
| `Product line` | `PRODUCT_LINE.product_line_name`, resolved to `SALE_LINE.product_line_id` | Map to lookup key |
| `Unit price` | `SALE_LINE.unit_price` | Convert CSV text to numeric value |
| `Quantity` | `SALE_LINE.quantity` | Convert CSV text to integer |
| `Tax 5%` | `SALE_LINE.tax_amount` | Convert CSV text to numeric value; validate calculation |
| `Sales` | `SALE_LINE.sales_amount` | Convert CSV text to numeric value |
| `Date` | `SALE.sale_date` | Parse `M/D/YYYY` into a date |
| `Time` | `SALE.sale_time` | Parse `H:MM:SS AM/PM` into a time-capable value |
| `Payment` | `PAYMENT_METHOD.payment_method_name`, resolved to `SALE.payment_method_id` | Map to lookup key |
| `cogs` | `SALE_LINE.cogs` | Convert CSV text to numeric value |
| `gross margin percentage` | Dropped from 3NF target | It is the same derived percentage in all 1,000 rows; validate and document during loading, but calculate it for reporting rather than storing a redundant constant |
| `gross income` | `SALE_LINE.gross_income` | Convert CSV text to numeric value |
| `Rating` | `SALE.rating` | Convert CSV text to numeric value and validate range |

## Deliverable status

This logical design is the blueprint for the Oracle implementation. Oracle-specific data types, sizes, and constraints will be selected in the physical database phase.
