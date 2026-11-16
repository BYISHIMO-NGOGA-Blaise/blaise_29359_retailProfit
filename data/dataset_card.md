# Dataset card: Supermarket Sales

## Source
- Dataset title: Supermarket Sales Dataset
- Source: Kaggle, Fares Ashraf
- Source link: https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales
- License: Apache 2.0
- File in repository: [data/raw/SuperMarket Analysis.csv](./raw/SuperMarket%20Analysis.csv)
- Format: CSV, UTF-8 text file
- Downloaded for project use on: 2026-11-16

## What the raw record represents
Each row records one sale transaction for a branch and a product line. A single record contains invoice information, branch and city details, customer type, gender, product category, price, quantity, tax, sales value, cost of goods sold, gross income, date/time, payment method, and a customer rating.

## Dataset profile
- Total rows: 1,000
- Total columns: 17
- File size: 140,285 bytes
- Example invoice ID: 750-67-8428

## Data quality checks
The source file was inspected before any cleaning.

- Missing values: 0 across all columns
- Duplicate invoice IDs: 0
- Distinct branch names: 3 (`Alex`, `Cairo`, `Giza`)
- Distinct cities: 3 (`Yangon`, `Naypyitaw`, `Mandalay`)
- Distinct customer types: 2 (`Member`, `Normal`)
- Distinct payment methods: 3 (`Cash`, `Credit card`, `Ewallet`)
- Distinct product lines: 6 (`Electronic accessories`, `Fashion accessories`, `Food and beverages`, `Health and beauty`, `Home and lifestyle`, `Sports and travel`)
- Date range: 2019-01-01 to 2019-03-09
- Fixed gross margin percentage: 4.761904762 for all rows; retained in the raw CSV but omitted from the normalized tables because it is a constant derived measure
- Key issue: several measures are stored as text in the CSV (for example `Unit price`, `Quantity`, `Tax 5%`, `Sales`, `cogs`, `gross income`, and `Rating`) and will need NUMBER conversion during Phase IV
- Date and time are stored as text strings in `MM/DD/YYYY` and `HH:MM:SS AM/PM` formats and will need DATE/TIMESTAMP conversion

## Quality notes
No rows were removed or corrected in this phase. The raw file is kept intact in `data/raw` and will be cleaned in Phase IV as part of the loading and validation stage.
