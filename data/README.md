# Data

## Source

- **Dataset:** Bank Marketing
- **Authors:** Sérgio Moro, Paulo Rita, and Paulo Cortez (2014)
- **Repository:** UCI Machine Learning Repository
- **URL:** https://doi.org/10.24432/C5K306
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **File:** `bank-additional-full.csv`
- **Rows:** 41,188
- **Columns:** 21
- **Period:** May 2008–November 2010, ordered by contact date

## Audit summary

- `y`: 4,640 subscribed (11.3%), 36,548 did not subscribe (88.7%).
- Unknown values: `default` 8,597; `education` 1,731; `housing` 990; `loan` 990; `job` 330; `marital` 80.
- Contact channel: cellular 26,144; telephone 15,044.
- Current-campaign contacts: minimum 1, maximum 56, average 2.57.
- Contacts above 3: 7,635 records; above 5: 3,385 records.
- No names, phone numbers, or national ID numbers are present.

## Important limitation

The dataset has no customer IDs, exact dates, or consent flags. In Phase II, a surrogate `customer_id` will be assigned to each row, a chronological contact sequence will be reconstructed from the file order and the `month` column, and a `consent` table will be seeded with documented simulated consent values for demonstration. The `duration` field is known only after a call and will not be used to decide whether a customer may be contacted.

## Attribution

Moro, S., Rita, P., & Cortez, P. (2014). *Bank marketing* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5K306

The dataset is used for educational purposes under CC BY 4.0. Any transformed tables created in later phases will be documented in the `sql/` folder.
