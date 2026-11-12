# Data

The downloaded source file is [SuperMarket Analysis.csv](SuperMarket%20Analysis.csv). It contains 1,000 rows and 17 columns (140,285 bytes) and comes from Fares Ashraf's [Supermarket Sales Dataset on Kaggle](https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales), Version 2. The dataset listing describes transaction-level sales from a supermarket chain in Myanmar, including branch, product line, quantity, unit price, total, cost of goods sold, and gross income.

The original CSV is kept unchanged. Use a separate cleaned copy for preparation and loading. Before loading into Oracle, check the row count, duplicate invoice IDs, data types, and calculations.

**Attribution:** Ashraf, F. (2024). *Supermarket sales dataset* (Version 2) [Data set]. Kaggle. https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales

The Kaggle listing identifies the dataset license as Apache 2.0 ([license text](https://www.apache.org/licenses/LICENSE-2.0)). Do not include credentials or Kaggle tokens in this repository.

The source has no stock-on-hand or explicit discount field. Its gross-margin-percentage field is reported as a fixed value, so comparisons will focus on gross-income amounts and the source margin definition will be checked during data validation.
