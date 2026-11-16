# Logical data dictionary and table structures

This is the logical design for the Phase II schema. It intentionally lists no Oracle data types or sizes; those belong in the physical database phase.

**Legend:** PK = primary key; FK = foreign key; required = must have a value; unique = no other row may have the same value.

## 1. `CITY`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `city_id` | PK | Identifier for a city | Yes | Yes |
| `city_name` | Alternate key | City name from the source | Yes | Yes |

## 2. `BRANCH`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `branch_id` | PK | Identifier for a branch | Yes | Yes |
| `branch_name` | Alternate key | Branch label from the source (`Alex`, `Cairo`, or `Giza`) | Yes | Yes |
| `city_id` | FK → `CITY.city_id` | City where the branch is located | Yes | No |

Each branch belongs to one city. The source currently contains one branch per city.

## 3. `CUSTOMER_TYPE`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `customer_type_id` | PK | Identifier for a customer segment | Yes | Yes |
| `customer_type_name` | Alternate key | Segment label (`Member` or `Normal`) | Yes | Yes |

## 4. `PAYMENT_METHOD`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `payment_method_id` | PK | Identifier for a payment method | Yes | Yes |
| `payment_method_name` | Alternate key | Payment label (`Cash`, `Credit card`, or `Ewallet`) | Yes | Yes |

## 5. `PRODUCT_LINE`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `product_line_id` | PK | Identifier for a product category | Yes | Yes |
| `product_line_name` | Alternate key | Product category label from the source | Yes | Yes |

The source identifies product-line categories, not individual products.

## 6. `SALE`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `sale_id` | PK | Source invoice identifier | Yes | Yes |
| `sale_date` |  | Date on which the sale occurred | Yes | No |
| `sale_time` |  | Time at which the sale occurred | Yes | No |
| `branch_id` | FK → `BRANCH.branch_id` | Branch where the sale occurred | Yes | No |
| `customer_type_id` | FK → `CUSTOMER_TYPE.customer_type_id` | Customer segment for the transaction | Yes | No |
| `gender` |  | Gender value recorded for the transaction; not a customer identifier | Yes | No |
| `payment_method_id` | FK → `PAYMENT_METHOD.payment_method_id` | Payment method used | Yes | No |
| `rating` |  | Customer rating recorded for the transaction | Yes | No |

## 7. `SALE_LINE`

| Column | Key | Meaning | Required | Unique |
|---|---|---|---|---|
| `sale_line_id` | PK | Identifier for a sale line | Yes | Yes |
| `sale_id` | FK → `SALE.sale_id` | Sale/invoice containing this line | Yes | No |
| `product_line_id` | FK → `PRODUCT_LINE.product_line_id` | Product-line category sold | Yes | No |
| `unit_price` |  | Unit selling price | Yes | No |
| `quantity` |  | Number of units sold | Yes | No |
| `tax_amount` |  | Tax amount recorded for the line | Yes | No |
| `sales_amount` |  | Sales amount recorded for the line | Yes | No |
| `cogs` |  | Cost of goods sold recorded for the line | Yes | No |
| `gross_income` |  | Gross income recorded for the line | Yes | No |

## Relationships, cardinality, and optionality

| Parent | Child | Relationship | Optionality |
|---|---|---|---|
| `CITY` | `BRANCH` | One city to zero or many branches (1:M) | A branch must reference exactly one city; a city may have no branches |
| `BRANCH` | `SALE` | One branch to zero or many sales (1:M) | A sale must reference exactly one branch; a branch may have no sales |
| `CUSTOMER_TYPE` | `SALE` | One customer type to zero or many sales (1:M) | A sale must reference exactly one type; a type may be unused |
| `PAYMENT_METHOD` | `SALE` | One payment method to zero or many sales (1:M) | A sale must reference exactly one method; a method may be unused |
| `SALE` | `SALE_LINE` | One sale to one or many lines (1:M) | Every line belongs to exactly one sale; the logical model requires at least one line per sale |
| `PRODUCT_LINE` | `SALE_LINE` | One product line to zero or many sale lines (1:M) | Each line must reference exactly one product line; a category may be unused |

The current CSV has one row per unique invoice and therefore produces one `SALE` and one `SALE_LINE` per source record. The 1:M sale-to-line relationship supports future data with multiple product lines per invoice; multiple lines per invoice are not present in this source.

## Data notes

- The dataset has no customer identifier. `CUSTOMER_TYPE` is a segment lookup; `gender` stays on `SALE`. There is deliberately no `CUSTOMER` table that would imply identifiable people.
- `sale_time`, `rating`, and all other listed source fields have values in all 1,000 records. They are marked required based on the source quality check.
- The source `gross margin percentage` has the same value in all 1,000 rows and is derivable from the sales measures; it is checked during loading but not stored in the normalized tables.
- Unique values shown as alternate keys are unique descriptions in this source. Surrogate identifiers are the logical primary keys.
