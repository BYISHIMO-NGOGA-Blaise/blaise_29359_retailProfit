# Data

The planned source is the [Supermarket Sales Dataset](https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales) on Kaggle. Its listing describes transaction-level sales from a supermarket chain in Myanmar and provides fields including branch, product line, quantity, unit price, total, cost of goods sold, and gross income. The listed download is a compact archive; the dataset is suitable for a manageable project sample.

Kaggle sign-in may be required to download the dataset. After downloading:

1. Keep the original file unchanged in `data/raw/`.
2. Record the downloaded version and source link in project documentation.
3. Use a separate cleaned copy for preparation and loading.
4. Check row count, duplicate invoices, data types, and calculations before loading into Oracle.

The listing identifies the dataset license as Apache 2.0. Include the attribution and license notice if redistributing the data. Do not include any credentials or Kaggle tokens in this repository.

The source has no stock-on-hand or explicit discount field. Its gross-margin-percentage field is reported as a fixed value, so comparisons will focus on gross-income amounts and the source margin definition will be checked during data validation.
